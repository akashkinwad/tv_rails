class SignRoyalty
  attr_reader :data

  def initialize(data)
    @data = JSON.parse(data)
  end

  def generate_signature
    url = URI("http://104.248.251.208/sign/royalty")

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
  #     "offerId": 8,
  #     "royaltyNominator": 100,
  #     "payees": [
  #         "0x1a3275748E520B9C117290329F150E67B182EfF7"
  #     ],
  #     "shares": [
  #         2
  #     ]
  #   }
  # end

  def sign_nft_url
    "#{ENV['SIGN_NFT_URL']}/sign/royalty"
  end
end
