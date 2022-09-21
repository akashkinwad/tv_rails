require 'open-uri'

module ApplicationHelper
  def upload_to_s3(file, folder_path)
    puts "Uploading image to S3 folder_path: #{folder_path}"
    service = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
    file_path = folder_path.gsub(' ', '')
    obj = service.bucket(ENV['S3_BUCKET']).object(file_path)
    obj.put({ acl: "public-read", content_type: 'image/jpeg', body: file })
    puts "Successfully uploaded image to S3 URL: #{obj.public_url.to_s}"

    # return URI.decode(obj.public_url.to_s)
    obj.public_url
  end

  def upload_to_s3_secure(file, folder_path)
    service = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
    name = folder_path.gsub(' ', '')
    obj = service.bucket(ENV['S3_BUCKET']).object(name)
    obj.put({ acl: "public-read", content_type: 'image/jpeg', body: file, server_side_encryption: "AES256" })
    return URI.decode(obj.public_url.to_s)
  end

end
