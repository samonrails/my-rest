class Admin::AccountPricingTiersController < ApplicationController
  load_and_authorize_resource :only => [:new, :edit, :update, :create, :destroy]

  def new
    @account_pricing_tier = AccountPricingTier.new
  end

  def edit
    @account_pricing_tier = AccountPricingTier.find(params[:id])
  end

  def update
    @account_pricing_tier = AccountPricingTier.find(params[:id])
    if @account_pricing_tier.update_attributes(permitted_params.account_pricing_tier)
      flash[:notice] = "Account pricing tier updated."

      redirect_to account_path(@account_pricing_tier.account, :selected => "pricing_tiers")
    else
      flash[:error] = "Error updating account pricing tier."
      redirect_to account_path(@account_pricing_tier.account, :selected => "pricing_tiers")
    end
  end

  def create
    @account_pricing_tier = AccountPricingTier.new(permitted_params.account_pricing_tier)
		
    if @account_pricing_tier.save
      flash_and_redirect("Account Pricing Tier Saved", account_path(@account_pricing_tier.account, :selected => "pricing_tiers"))
    else
      flash_and_redirect("Error creating Pricing Tier: check for missing information", account_path(@account_pricing_tier.account, :selected => "pricing_tiers"))
    end
  end

  def destroy
    @account_pricing_tier = AccountPricingTier.find(params[:id])

    if @account_pricing_tier.destroy
      flash_and_redirect("Account Pricing Tier Deleted", account_path(@account_pricing_tier.account, :selected => "pricing_tiers"))
    else
      flash_and_redirect("Error deleting Pricing Tier", account_path(@account_pricing_tier.account, :selected => "pricing_tiers"))
    end
  end

end
