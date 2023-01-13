class SignNft
  attr_reader :data

  def initialize(data)
    @data = JSON.parse(data)
  end

  def process
    details = generate_signature
    update_nft_details(details)
  end

  def update_nft_details(details)
    @user.update(nft_details: details)
  end

  def generate_signature
    url = URI("http://104.248.251.208/sign/nft")

    http = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Post.new(url)
    request['Content-Type'] = 'application/json'
    request.body = JSON.dump(data)

    response = http.request(request)
    JSON.parse(response.read_body)
  end

  private

  # def data
  #   {
  #     "offerCreator": "0x1a3275748E520B9C117290329F150E67B182EfF7",
  #     "offerId": 111,
  #     "nftContractAdr": "0x4dc7ef5515c5DF15C3060C7eB70db12897FbF0E7",
  #     "offerAmount": 1,
  #     "nftId": 12,
  #     "startPrice": "1000000000000000000",
  #     "targetPrice": "10000000000000000000",
  #     "offerEnd": 1671807529,
  #     "maxSupply": 10,
  #     "highestBid": "1000000000000000000",
  #     "bidder": "0x1a3275748E520B9C117290329F150E67B182EfF7",
  #     "closed": false
  #   }
  # end

  def sign_nft_url
    "#{ENV['SIGN_NFT_URL']}/sign/nft"
  end
end
