# frozen_string_literal: true

require 'json'
require 'aws-sdk-s3'
require './src/image_helper'

def lambda_handler(event:, context:)
  s3 = Aws::S3::Resource.new(
      region: ENV['REGION'],
      access_key_id: ENV['ACCESS_KEY'],
      secret_access_key: ENV['SECRET_ACCESS_KEY'],
    )
    bucket_name = 'yudedako-rubylambda-sandbox'
    file_name = 'helloworld.png'

    # Upload Image to S3
    file = ImageHelper.build(event['message']).tempfile.open.read
    s3.bucket(bucket_name).object(file_name).put(body: file)

    # Get Image from S3
    object = s3.bucket(bucket_name).object(file_name)
    {
    statusCode: 200,
    url: object.public_url,
    }
end

# for exec local
if __FILE__ == $0
    lambda_handler(event: { 'message' => 'Hello, PrAha!' }, context: nil)
end
