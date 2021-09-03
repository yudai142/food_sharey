require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id:  ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: 'ap-northeast-1'
    }

    config.fog_directory  = 'aws-and-infra-strage-image'
    config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/aws-and-infra-strage-image'
  end

else
  CarrierWave.configure do |config|
    config.storage = :file
  end
end
