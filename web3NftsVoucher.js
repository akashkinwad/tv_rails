import {provider, currentAccount, toWei, approve, paymentTokenContract} from './web3Base.js';

import marketplaceVoucherAbi from '../../data/abis/marketplaceVoucher.json';
import nftVoucherAbi from '../../data/abis/nftVoucher.json';
import royaltyReceiverAbi from '../../data/abis/royaltyReceiver.json';

const marketPlaceAddress = "0xF08A9502eB874a803f757574e2F8730D39F0C7d2";
const nftAddress = "0x749fcF03848D7e5Fc9c8f78739253B3Ec626a763";
const royaltyReceiverAddress = "0xc014f2a0169a6b3426B78f03CCB8e9c75778d111";

const marketPlaceContract = new provider.Contract(marketplaceVoucherAbi, marketPlaceAddress);
const nftContract = new provider.Contract(nftVoucherAbi, nftAddress);
const royaltyReceiverContract = new provider.Contract(royaltyReceiverAbi, royaltyReceiverAddress);

const backendUrl = "http://104.248.251.208";


// ---- APPROVAL ----

/**
 * Returns the approval state of an amount of one specific nft.
 * 
 * @param {number} nftId
 * @returns {Promise<boolean>}
 */
async function isNftApproved(nftId) {
	return nftContract.methods.allowance(currentAccount, marketPlaceAddress, nftId).call().then((result) => {
		return parseInt(result) > 0;
	});
}

/**
 * Approves an amount of one specific nft.
 * 
 * @param {number} nftId
 * @param {number} amount
 * @returns {Promise<void>}
 */
async function setNftApproved(nftId, amount) {
	return nftContract.methods.approveSingleId(marketPlaceAddress, nftId, amount).send({from: currentAccount});
}

/**
 * Checks if all nfts are already approved and if not,
 * it triggers a metamask popup for approving all nfts.
 * 
 * @param {number} nftId
 * @param {number} amount
 * @returns {Promise<void>}
 */
async function approveNft(nftId, amount) {
	let isApproved = await isNftApproved(nftId);

	if (!isApproved) {
		return approveNft(nftId, amount);
	} else {
		return Promise.resolve();
	}
}

// ---- MINT ----

/**
 * Triggers a metamask popup for minting nfts by talentsverse.
 * 
 * @param {number} nftId
 * @param {number} amount how many nfts
 * @param {number} maxSupply TODO
 * @param {number} royaltyNominator how much royalty (1=0.01% -- 100000=100%, e.g. 1000=1%)
 * @param {Array<address>} payees who gets royalty
 * @param {Array<number>} shares how much royalty to the payees get
 * @returns {Promise<void>}
 */
async function mintNftByTalentsverse(nftId, amount, maxSupply, royaltyNominator, payees, shares) {
	return nftContract.methods.mintByTalentsVers(
		currentAccount,
		nftId,
		amount,
		maxSupply,
		"0x",
		royaltyNominator,
		currentAccount,
		payees,
		shares
	).send({from: currentAccount}).then((result) => {
		return parseInt(result.events.TransferSingle.returnValues.id);
	});
}

// ---- OFFER DATA ----

/**
 * Returns how many offers currently exist.
 * 
 * @returns {Promise<number>}
 */
async function getOfferCount() {
	return marketPlaceContract.methods.offerCount().call();
}

/**
 * Returns offer data for a specific offer.
 * 
 * @param {number} offerId
 * @returns {Promise<Object>}
 */
async function getOfferData(offerId) {
	return marketPlaceContract.methods.offers(offerId).call();
}

/**
 * Returns offer data for all offers.
 * 
 * @returns {Array<Object>}
 */
async function getAllOfferData() {
	let offerCount = await getOfferCount();

	let allOffers = [];
	let currentOffer = undefined;
	for (let i = 0; i < parseInt(offerCount); i++) {
		currentOffer = await getOfferData(i);

		Object.keys(currentOffer).forEach(key => {
			if (Number.isInteger(parseInt(key))) {
				delete currentOffer[key];
			}
		});

		allOffers.push(currentOffer);
	}

	return allOffers;
}

// ---- OFFER - CREATE ----

/**
 * Triggers a metamask popup for creating an offer with a voucher and bids.
 * THIS FUNCTION NEEDS TO BE CALLED FOR THE FIRST TIME SOMEONE BIDS TO A NOT YET MINTED NFT.
 * 
 * @param {address} offerCreator
 * @param {number} offerId
 * @param {number} offerAmount
 * @param {number} nftId
 * @param {number} startPrice
 * @param {number} targetPrice
 * @param {Date} offerEnd
 * @param {number} maxSupply
 * @param {number} bidAmount
 * @returns {Promise<number>}
 */
async function createOfferAndBid(offerCreator, offerId, offerAmount, nftId, startPrice, targetPrice, offerEnd, maxSupply, bidAmount) {
	let weiStartPrice = await toWei(startPrice);
	let weiTargetPrice = await toWei(targetPrice);
	let unixOfferEnd = Math.floor(offerEnd.getTime() / 1000);
	let weiBidAmount = await toWei(bidAmount);

	let params = {
		offerCreator: offerCreator,
		offerId: offerId,
		nftContractAdr: nftAddress,
		offerAmount: offerAmount,
		nftId: nftId,
		startPrice: weiStartPrice,
		targetPrice: weiTargetPrice,
		offerEnd: unixOfferEnd,
		maxSupply: maxSupply,
		highestBid: weiBidAmount,
		bidder: currentAccount,
		closed: false
	};

	let response = await fetch(backendUrl + '/sign/nft', {
		method: 'POST',
		mode: 'cors',
		headers: {
			'Accept': 'application/json',
			'Content-Type': 'application/json'
		},
		body: JSON.stringify(params)
	});

	let json = await response.json();

	return approve(paymentTokenContract, marketPlaceAddress).then(() => {
		return marketPlaceContract.methods.makeBidFirstBid(
			weiBidAmount,
			params,
			json.hashMessage,
			json.signature
		).send({from: currentAccount}).then((result) => {
			return parseInt(result.events.CreatedOffer.returnValues.id);
		});
	});
}

// ---- OFFER - INTERACTIONS ----

/**
 * Triggers a metamask popup for making a bid to an existing offer.
 * If the user bids the target price, the nft is NOT transfered immediately, the user still needs to claim it.
 * USE THIS ONLY IF THE FIRST BID WITH "createOfferAndBid" WAS ALREADY MADE!
 * 
 * @param {number} offerId
 * @param {number} amount
 * @returns {Promise<void>}
 */
async function makeBid(offerId, amount) {
	let weiAmount = await toWei(amount);

	return approve(paymentTokenContract, marketPlaceAddress).then(() => {
		return marketPlaceContract.methods.makeBid(offerId, weiAmount, "0x").send({from: currentAccount});
	});
}

/**
 * Triggers a metamask popup for claiming an offer.
 * 
 * @param {number} offerId
 * @param {number} royaltyNominator how much royalty (1=0.01% -- 100000=100%, e.g. 1000=1%)
 * @param {Array<address>} payees who gets royalty
 * @param {Array<number>} shares how much royalty to the payees get
 * @returns {Promise<void>}
 */
async function claimOffer(offerId, royaltyNominator, payees, shares) {
	let params = {
		offerId: offerId,
		royaltyNominator: royaltyNominator,
		payees: payees,
		shares: shares
	};

	let response = await fetch(backendUrl + '/sign/royalty', {
		method: 'POST',
		mode: 'cors',
		headers: {
			'Accept': 'application/json',
			'Content-Type': 'application/json'
		},
		body: JSON.stringify(params)
	});

	let json = await response.json();

	return marketPlaceContract.methods.claimOffer(
		offerId,
		royaltyNominator,
		payees,
		shares,
		json.hashMessage,
		json.signature
	).send({from: currentAccount});
}
