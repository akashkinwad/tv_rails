if (window.ethereum) {
  var web3Provider = window.ethereum;
  try {
    // Request account access
    await window.ethereum.enable();
  } catch (error) {
    // User denied account access...
    console.error("User denied account access")
  }
}
// Legacy dapp browsers...
else if (window.web3) {
  var web3Provider = window.web3.currentProvider;
}
// If no injected web3 instance is detected, fall back to Ganache
else {
  var web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
}



async function fetchJson() {
  try {
    var data = await fetch(url);
    var marketplaceAbi = await data.json();
    console.log('marketplaceAbi ====>', marketplaceAbi);
  } catch (error) {
    console.log(error);
  }
};

fetchJson();

const url = "/user/json/marketplace.json";

const fetchJson = async () => {
  try {
    const data = await fetch(url);
    const response = await data.json();
    console.log('response====>', response);
  } catch (error) {
    console.log(error);
  }
};

fetchJson();

$(document).ready(function () {
  $.ajax({
    url: url,
    type: 'GET',
    dataType: 'json',
    success: function (code, statut) {
      for (let i in code) {
        console.log(i)
      }
    }
  });
});


// https://flaviocopes.com/how-to-return-result-asynchronous-function/
// https://javascript.plainenglish.io/async-await-javascript-5038668ec6eb


