import Web3 from "web3";

import basicTokenAbi from '../../data/abis/basicToken.json';
import marketplaceAbi from '../../data/abis/marketplace.json';
import nftAbi from '../../data/abis/nft.json';
import paymentTokenAbi from '../../data/abis/paymentToken.json';


const backendUrl = "http://104.248.251.208";

const marketPlaceAddress = "0x7aE5B2215Cb8330753Ec60a126778643A6499Bc0";
const nftAddress = "0xa5399a1EE519F12A95E86766168308bda2aF82F1";
const paymentTokenAddress = "0x39E77C8Bc081F20a7AA3a6027Db438FB5DAA1Aa0";

const defaultProvider = "https://data-seed-prebsc-1-s1.binance.org:8545";

let provider = (new Web3(Web3.givenProvider ?? defaultProvider)).eth;
let currentAccount = undefined;

const marketPlaceContract = new provider.Contract(marketplaceAbi, marketPlaceAddress);
const nftContract = new provider.Contract(nftAbi, nftAddress);
const paymentTokenContract = new provider.Contract(paymentTokenAbi, paymentTokenAddress);

// ---- RELOAD ON CHANGE ----

/**
 * Reload the page if the selected chain or account is changed.
 */
if (window.ethereum) {
    window.ethereum.on('chainChanged', () => {
        window.location.reload();
    });
    window.ethereum.on('accountsChanged', () => {
        window.location.reload();
    });
}

// ---- BASE ----

/**
 * Returns the connected account if the user is connected.
 *
 * @returns {address} current account
 */
async function getAccount() {
  let accounts = await provider.getAccounts();

  currentAccount = accounts[0];

  return currentAccount;
}

/**
 * Triggers the metamask login popup and returns the connected account if the user connects to metamask.
 *
 * @returns {address} current account
 */
async function requestAccount() {
  let accounts = await provider.requestAccounts();

  currentAccount = accounts[0];

  return currentAccount;
}

/**
 * Returns the native balance (e.g. BNB on BSC) of a wallet.
 *
 * @param {address} ofAddress
 * @returns {Promise<string>}
 */
async function getNativeBalance(ofAddress) {
  return provider.getBalance(ofAddress);
}

/**
 * Returns a balance of a token of a wallet.
 *
 * @param {address} tokenAddress
 * @param {address} ofAddress
 * @returns {Promise<string>}
 */
async function getBalance(tokenAddress, ofAddress) {
  let tokenContract = new provider.Contract(basicTokenAbi, tokenAddress);

  return tokenContract.methods.balanceOf(ofAddress).call();
}

/**
 * Returns the wei in the eth format (wei / 10 ** 18).
 *
 * @param {string} wei
 * @returns {Promise<string>}
 */
async function fromWei(wei) {
  return Web3.utils.fromWei(wei);
}

/**
 * Returns the number in the wei format (number * 10 ** 18).
 *
 * @param {number} number
 * @returns {Promise<string>}
 */
async function toWei(number) {
    return Web3.utils.toWei(number.toString());
}

// ---- APPROVE ----

/**
 * Returns the allowance for approving a token to a contract.
 *
 * @param {Contract} baseContract
 * @param {address} toApproveContract
 * @returns {Promise<void>}
 */
async function getAllowance(baseContract, toApproveContract) {
  return baseContract.methods.allowance(currentAccount, toApproveContract).call();
}

/**
 * Triggers an approval for the max number amount for a token to a contract.
 * If the token is already approved, nothing happens.
 *
 * @param {Contract} baseContract
 * @param {address} toApproveContract
 * @returns {Promise<void>}
 */
async function approve(baseContract, toApproveContract) {
  let maxAmount = Web3.utils.toBN(2).pow(Web3.utils.toBN(256)).sub(Web3.utils.toBN(1)).toString();
  let allowance = await getAllowance(baseContract, toApproveContract);

  if (allowance !== maxAmount) {
    return baseContract.methods.approve(toApproveContract, maxAmount).send({from: currentAccount});
  } else {
    return Promise.resolve();
  }
}

// ---- METAMASK ----

/**
 * Triggers a metamask popup for switching to the specified chain.
 * If the chain is not present in metamask, a popup will appear for adding it.
 *
 * @param {string} hex
 * @param {string} name
 * @param {string} currency
 * @param {string} url
 * @param {string} blockExplorerUrl
 * @returns {Promise<void>|void}
 */
async function switchChain(hex, name, currency, url, blockExplorerUrl) {
  return window.ethereum.request({
    method: 'wallet_switchEthereumChain',
    params: [{ chainId: hex }],
  }).catch((error) => {
    if (error && (error.code === 4902 || error.data?.originalError?.code === 4902)) {
      return window.ethereum.request({
        method: 'wallet_addEthereumChain',
        params: [{
          chainId: hex,
          chainName: name,
          nativeCurrency: currency,
          rpcUrls: [url],
          blockExplorerUrls: [blockExplorerUrl],
        }],
      }).catch((error) => {
        console.log(error);
      });
    } else {
      console.error(error);
    }
  });
}

/**
 * Triggers a metamask popup for adding the specified token to metamask.
 *
 * @param {address} contract
 * @param {string} symbol
 * @param {number} decimals
 * @returns {Promise<void>}
 */
async function addTokenToMetamask(contract, symbol, decimals) {
  return window.ethereum.request({
    method: 'wallet_watchAsset',
    params: {
      type: 'ERC20',
      options: {
        address: contract,
        symbol: symbol,
        decimals: decimals
      },
    },
  });
}

// ---- NFT ----

/**
 * Returns the approval state for the user.
 *
 * @returns {Promise<boolean>}
 */
async function isNftApproved() {
  return nftContract.methods.isApprovedForAll(currentAccount, marketPlaceAddress).call();
}

/**
 * Sets the approval state for the user.
 *
 * @param {boolean} state
 * @returns {Promise<boolean>}
 */
async function setNftApproved(state) {
  return nftContract.methods.setApprovalForAll(marketPlaceAddress, state).send({from: currentAccount});
}

/**
 * Triggers a metamask popup for approving the nfts.
 *
 * @param {boolean} state
 * @returns {Promise<boolean>}
 */
async function approveNft() {
  let isApproved = await isNftApproved();

  if (!isApproved) {
    return setNftApproved(true);
  } else {
    return Promise.resolve();
  }
}

/**
 * Triggers a metamask popup for minting nfts.
 *
 * @param {number} amount
 * @returns {Promise<void>}
 */
async function mintNft(amount) {
  let id = parseInt(Math.random() * 1000000 + 250000);

  return nftContract.methods.mintOneTimeNFT(currentAccount, id, amount, "0x").send({from: currentAccount}).then((result) => {
    return parseInt(result.events.TransferSingle.returnValues.id);
  });
}

// ---- MARKETPLACE ----

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
  for (let i = 1; i <= parseInt(offerCount); i++) {
    currentOffer = await getOfferData(i);
    // TODO: 0-11 deleten

    allOffers.push(currentOffer);
  }

  return allOffers;
}

/**
 * Triggers a metamask popup for making a bid to an existing offer.
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
 * Triggers a metamask popup for creating an offer without a voucher.
 *
 * @param {number} nftId
 * @param {number} offerAmount
 * @param {number} startPrice
 * @param {number} targetPrice
 * @param {Date} offerEnd
 * @returns {Promise<void>}
 */
async function createOfferWithoutVoucher(nftId, offerAmount, startPrice, targetPrice, offerEnd) {
  return approveNft().then(async () =>  {
    let weiStartPrice = await toWei(startPrice);
    let weiTargetPrice = await toWei(targetPrice);
    let unixDate = Math.floor(offerEnd.getTime() / 1000);

    return marketPlaceContract.methods.createOfferWithoutVoucher(
      [currentAccount],
      [nftAddress],
      [nftId],
      [offerAmount],
      [weiStartPrice],
      [weiTargetPrice],
      [unixDate]
    ).send({from: currentAccount});
  });
}

/**
 * Triggers a metamask popup for creating an offer with a voucher.
 *
 * @param {number} nftId
 * @param {number} offerAmount
 * @param {number} startPrice
 * @param {number} targetPrice
 * @param {Date} offerEnd
 * @returns {Promise<void>}
 */
async function createOfferWithVoucher(nftId, offerAmount, startPrice, targetPrice, offerEnd) {
  let weiStartPrice = await toWei(startPrice);
  let weiTargetPrice = await toWei(targetPrice);
  let unixDate = Math.floor(offerEnd.getTime() / 1000);
  let maxSupply = 10;

  let response = await fetch(backendUrl + '/signNFT', {
    method: 'POST',
    mode: 'cors',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      creator: currentAccount,
      nftContract: nftAddress,
      id: nftId,
      offerAmount: offerAmount,
      startPrice: weiStartPrice,
      endPrice: weiTargetPrice,
      endTime: unixDate,
      maxSupply: maxSupply
    })
  });

  let json = await response.json();

  return marketPlaceContract.methods.createOfferWithVoucher(
    [currentAccount],
    [nftAddress],
    [nftId],
    [offerAmount],
    [weiStartPrice],
    [weiTargetPrice],
    [unixDate],
    [maxSupply],
    [json.hashMessage],
    [json.signature]
  ).send({from: currentAccount});
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
