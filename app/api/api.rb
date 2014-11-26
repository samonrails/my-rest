class Api < Grape::API
  prefix 'api'
  version 'v1', using: :path 
  mount Catering::PingApi
  mount Catering::UserApi
  mount Catering::MenuApi
end