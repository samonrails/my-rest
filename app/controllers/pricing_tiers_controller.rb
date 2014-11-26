class PricingTiersController < ApplicationController
  authorize_resource
  respond_to :html

  def index
    respond_with(@pricing_tiers = PricingTier.all)
  end

  def show
    respond_with(@pricing_tier = PricingTier.find(params[:id]))
  end

  def new
    respond_with(@pricing_tier = PricingTier.new)
  end

  def edit
    respond_with(@pricing_tier = PricingTier.find(params[:id]))
  end

  def create
    @pricing_tier = PricingTier.new(permitted_params.pricing_tier)

    if @pricing_tier.save
      flash[:notice] = "PricingTier was created successfully."
    else
      flash[:error] = "Error creating Pricing Tier: " + @pricing_tier.errors.full_messages.join(", ")
    end

    redirect_to admin_root_path(:selected => "pricing_tiers")
  end

  def update
    @pricing_tier = PricingTier.find(params[:id])

    if @pricing_tier.update_attributes(permitted_params.pricing_tier)
      flash[:notice] = "Pricing Tier was updated successfully."
    else
      flash[:error] = "Error updating Pricing Tier: " + @pricing_tier.errors.full_messages.join(", ")
    end
    redirect_to admin_root_path(:selected => "pricing_tiers")

  end

  def destroy
    @pricing_tier = PricingTier.find(params[:id])
    begin
      @pricing_tier.destroy
      flash[:notice] = "Pricing tier deleted."
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying pricing tier - " + e.to_s
    end
    redirect_to admin_root_path(:selected => "pricing_tiers")

  end

end
