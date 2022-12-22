import {provider, currentAccount, toWei, approve, paymentTokenContract} from './web3Base.js';

import marketplaceAbi from '../../data/abis/marketplace.json';
import nftAbi from '../../data/abis/nft.json';
import royaltyReceiverAbi from '../../data/abis/royaltyReceiver.json';

const marketPlaceAddress = "0xE66ad995B5a39D132B1dB785FE395b7f13099dd7";
const nftAddress = "0x74DdF16869FbAbD3811194FBb4D4c072b70E120F";
const royaltyReceiverAddress = "0x35dD25c53f792132C649bc21F790d560986a0A82";

const marketPlaceContract = new provider.Contract(marketplaceAbi, marketPlaceAddress);
const nftContract = new provider.Contract(nftAbi, nftAddress);
const royaltyReceiverContract = new provider.Contract(royaltyReceiverAbi, royaltyReceiverAddress);


// ---- NFT - APPROVAL ----

/**
 * Returns the approval state of all nfts.
 * 
 * @returns {Promise<boolean>}
 */
async function isNftApprovedForAll() {
	return nftContract.methods.isApprovedForAll(currentAccount, marketPlaceAddress).call();
}

/**
 * Approves of all nfts.
 * 
 * @returns {Promise<void>}
 */
async function setNftApprovedForAll() {
	return nftContract.methods.setApprovalForAll(marketPlaceAddress, true).send({from: currentAccount});
}

/**
 * Checks if all nfts are already approved and if not,
 * it triggers a metamask popup for approving all nfts.
 * 
 * @returns {Promise<void>}
 */
async function approveNfts() {
	let isApproved = await isNftApprovedForAll();

	if (!isApproved) {
		return setNftApprovedForAll();
	} else {
		return Promise.resolve();
	}
}

// ---- NFT - MINT ----

/**
 * Triggers a metamask popup for minting nfts.
 * 
 * @param {number} amount how many nfts
 * @param {number} royaltyNominator how much royalty (1=0.01% -- 100000=100%, e.g. 1000=1%)
 * @param {Array<address>} payees who gets royalty
 * @param {Array<number>} shares how much royalty to the payees get
 * @returns {Promise<void>}
 */
async function mintNft(amount, royaltyNominator, payees, shares) {
	return nftContract.methods.mint(
		currentAccount,
		amount,
		"0x",
		royaltyNominator,
		currentAccount,
		payees,
		shares
	).send({from: currentAccount}).then((result) => {
		return parseInt(result.events.TransferSingle.returnValues.id);
	});
}

// ---- OFFER - GET DATA ----

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
 * Triggers a metamask popup for creating an offer without a voucher.
 * 
 * @param {number} nftId
 * @param {number} offerAmount
 * @param {number} startPrice
 * @param {number} targetPrice
 * @param {Date} offerEnd
 * @returns {Promise<number>}
 */
async function createOffer(nftId, offerAmount, startPrice, targetPrice, offerEnd) {
	return approveNfts().then(async () =>  {
		let weiStartPrice = await toWei(startPrice);
		let weiTargetPrice = await toWei(targetPrice);
		let unixDate = Math.floor(offerEnd.getTime() / 1000);

		return marketPlaceContract.methods.createOffers(
			[currentAccount],
			[nftAddress],
			[nftId],
			[offerAmount],
			[weiStartPrice],
			[weiTargetPrice],
			[unixDate]
		).send({from: currentAccount}).then((result) => {
			return parseInt(result.events.CreatedOffer.returnValues.id);
		});
	});
}

// ---- OFFER - INTERACTIONS ----

/**
 * Triggers a metamask popup for making a bid to an existing offer.
 * If the user bids the target price, the nft is transfered immediately.
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
 * @returns {Promise<void>}
 */
async function claimOffer(offerId) {
	return marketPlaceContract.methods.claimOffer(offerId, "0x").send({from: currentAccount});
}
