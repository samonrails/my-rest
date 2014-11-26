# These are AWS default values. They are not suitable for production but they will can be used
# in development for quick setup. For a more stable configuration setup your application.yml file.

module AWS
  Key = ENV["AWS_ACCESS_KEY_ID"]
  Secret = ENV["AWS_SECRET_ACCESS_KEY"]
  Region = ENV["AWS_DEFAULT_REGION"]
  PublicBucket = ENV["AWS_S3_PUBLIC_BUCKET"]
  PrivateBucket = ENV["AWS_S3_PRIVATE_BUCKET"]
  PrivateWindow = ENV["AWS_S3_PRIVATE_WINDOW"]
end

