import Web3 from "web3";

import basicTokenAbi from '../../data/abis/basicToken.json';
import paymentTokenAbi from '../../data/abis/paymentToken.json';

const defaultProvider = "https://data-seed-prebsc-1-s1.binance.org:8545";
let provider = (new Web3(Web3.givenProvider ?? defaultProvider)).eth;
let currentAccount = undefined;

const paymentTokenAddress = "0x39E77C8Bc081F20a7AA3a6027Db438FB5DAA1Aa0";
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

// ---- PAYMENT TOKEN ----

/**
 * Triggers a metamask popup for minting a big amount of the payment token.
 * This gives the user the opportunity to pay everything for testing purposes.
 * ONLY FOR TESTING!
 * 
 * @returns {Promise<void>}
 */
async function mintPaymentToken() {
	return paymentTokenContract.methods.mint().send({from: currentAccount});
}
