require 'ostruct'
require 'yaml'

all_config = YAML.load_file("#{Rails.root}/config/email.yml") || {}
env_config = all_config[Rails.env] || {}
MailConfig = OpenStruct.new(env_config)