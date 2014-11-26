module Catering 
  class PingApi < Grape::API
    format :json

    desc "Return pong."
    get :ping do
      { :ping => params[:pong] || 'pong'}
    end
  end
end