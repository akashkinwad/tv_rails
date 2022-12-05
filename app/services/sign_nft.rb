class SignNft
  attr_reader :user, :nft_contract

  def initialize(user_id)
    @user = User.find user_id
    @nft_contract = '0x8076c74c5e3f5852037f31ff0093eeb8c8add8d3'
  end

  def process
    details = generate_signature
    update_nft_details(details)
  end

  def update_nft_details(details)
    @user.update(nft_details: details)
  end

  def generate_signature
    url = URI("http://104.248.251.208/signNft")

    http = Net::HTTP.new(url.host, url.port);
    request = Net::HTTP::Post.new(url)
    request['Content-Type'] = 'application/json'
    request.body = JSON.dump(data)

    response = http.request(request)
    JSON.parse(response.read_body)
  end

  private

  def data
    {
      creator: @user.nft_account_id,
      nftContract: nft_contract,
      id: 12,
      offerAmount: 1,
      startPrice: 1,
      endPrice: 1,
      endTime: 1111111111,
      maxSupply: 1
    }
  end

  def sign_nft_url
    "#{ENV['SIGN_NFT_URL']}/signNft"
  end
end
