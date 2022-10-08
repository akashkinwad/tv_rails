require 'open-uri'

module UploadToS3
  def upload_to_s3(file, folder_path)
    mime_type = file.content_type rescue ""

    puts "Uploading #{mime_type} to S3 folder_path: #{folder_path}"
    body = open(file).read
    service = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
    file_path = folder_path.gsub(' ', '')
    obj = service.bucket(ENV['S3_BUCKET']).object(file_path)
    obj.put({ acl: "public-read", content_type: mime_type, body: body })
    puts "Successfully uploaded #{mime_type} to S3 URL: #{obj.public_url}"

    obj
  end
end
