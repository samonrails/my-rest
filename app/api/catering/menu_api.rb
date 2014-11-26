module Catering
  class MenuApi < Grape::API
    format :json

    resource :menu do

      desc "Return the menu-level pricing of a menu adjusted for account pricing tiers"
      params do
        requires :id, type: Integer, desc: "Menu id"
        optional :account_id, type: Integer, desc: "Account id"
      end
      route_param :id do
        get :sell_price do
          cogs = MenuTemplate.find(params[:id]).cogs_cents
          if params[:account_id]
            { :sell_price => CateringPricing.account_pricing_tier_price(cogs, params[:account_id]) }
          else
            { :sell_price => Event.calculate_sell_price_using_standard_pricing_tier(cogs) }
          end
        end
      end
    end
  end
end
