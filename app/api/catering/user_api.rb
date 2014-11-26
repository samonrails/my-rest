module Catering
  class UserApi < Grape::API
    format :json

    resource :user do

      desc "Return a users credit cards."
      params { requires :id, type: Integer, desc: "Requested User id" }
      route_param :id do
        get :credit_cards do
          
          { :card1 => "just testing" }

        end
      end
    end
  end
end
