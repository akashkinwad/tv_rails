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


// =====================

  let marketplaceAbi = undefined;
  let offerWithVoucher = '';
  let signature = '';
  let hashMessage = '';

  var signNft = {
    "url": "/api/v1/nfts/sign_nft",
    "method": "POST",
    "timeout": 0,
    "headers": {
      "Content-Type": "application/json"
    },
    "data": JSON.stringify({
      "creator": walletId,
      "nftContract": nftContract,
      "id": "30",
      "offerAmount": "1",
      "startPrice": "1",
      "endPrice": "10",
      "endTime": "1111111111",
      "maxSupply": "1"
    }),
  };

  const setMarketplaceAbi = async () => {
    try {
      var data = await fetch(url);
      marketplaceAbi = await data.json();

      return marketplaceAbi
    } catch (error) {
      console.log(error);
    }
  };

  const callSignNft = async () => {
    try {
      $.ajax(signNft).done(function (response) {
        signature = response['signature'];
        hashMessage = response['hashMessage'];
      });
    } catch (error) {
      console.log(error);
    }
  };

  const createOfferWithVoucher = async () => {
    try {
      var marketPlaceContract = new provider.Contract(marketplaceAbi, marketPlaceAddress);

      offerWithVoucher = marketPlaceContract.methods.createOfferWithVoucher(
        [walletId],
        [nftContract],
        ['30'],
        ['1'],
        ['1'],
        ['10'],
        ['1111111111'],
        ['1'],
        [hashMessage],
        [signature]
      ).send({ from: walletId })

      console.log('offerWithVoucher =>', offerWithVoucher);
    } catch (error) {
      console.log('Error in createOfferWithVoucher =>', error);
    }
  };

  setMarketplaceAbi();

  callSignNft();

  $('#createOfferWithVoucher').click(function(){
    //createOfferWithVoucher();
  });

  $('#new_nft_post').submit(function(event) {
    var formData = new FormData($(this)[0]);
    var action = $(this).attr('action');

    $.ajax({
      url: action,
      method: 'POST',
      headers: {
        'X-Transaction': 'POST Example',
        'X-CSRF-Token': token
      },
      data: formData,
    }).then(function(data) {
      debugger;
      console.log('Successs======>');
      $('#new_nft_post')[0].reset();
    });
  });


  $('#new_nft_post_old').submit(function(callback) {
    var d = new Date();

    createOfferWithVoucherNew(157, 10, 1, 1, d, function(result) { callback(result) });

    debugger;
    var formData = new FormData($(this)[0]);
    var action = $(this).attr('action');

    $.ajax({
      url: action,
      method: 'POST',
      headers: {
        'X-Transaction': 'POST Example',
        'X-CSRF-Token': token
      },
      data: formData,
      processData: false,
      contentType: false,
    }).then(function(data) {
      debugger;
      console.log('Successs======>');
      $('#new_nft_post')[0].reset();
    });
  });
