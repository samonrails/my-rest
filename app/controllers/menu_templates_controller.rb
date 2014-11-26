class MenuTemplatesController < ApplicationController
  authorize_resource
  respond_to :html, :json, :js

  def index
    respond_with(@menu_templates = current_vendor.menu_templates)
  end

  def edit
    respond_with(
      @menu_template = current_vendor.menu_templates.find(params[:id]),
      @available_items = find_inventory_items(params[:vendor_id], @menu_template.product_type)
    )
  end

  def new
    @menu_template = current_vendor.menu_templates.build
  end

  def create
    @menu_template = menu_templates.create(permitted_params.menu_template)

    if @menu_template.save
      flash[:notice] = "Menu Template created successfully."
      redirect_to edit_vendor_menu_template_path(current_vendor, @menu_template)
    else
      flash[:error] = "Error creating Menu Template - " + @menu_template.errors.full_messages.join(", ")
      render 'new'
    end
  end

  def update
    @menu_template = MenuTemplate.find(params[:id])
  
    is_default_menu_for_popup = params[:menu_template][:is_default] || 0
  
    # If we have selected this as a default menu for a popup, set the others to be false. 
    if is_default_menu_for_popup == '1'
      all_menu_templates_for_vendor = MenuTemplate.where(:vendor_id => params[:vendor_id], 
                                       :product_type => params[:menu_template][:product_type]).update_all({:is_default => false })
    end

    if @menu_template.update_attributes(permitted_params.menu_template)
      flash[:notice] = "Menu template updated successfully."
      redirect_to vendor_path(current_vendor, :selected => "menu_templates")
    else
      flash[:error] = "Error updating Menu Template - " + @menu_template.errors.full_messages.join(", ")
      render 'edit'
    end
  end

  def destroy
    @menu_template = MenuTemplate.find(params[:id])

    begin
      if @menu_template.is_default
        # Menu template is being deleted; choose another menu template of the same product type 
        # to make it default
        
        other_menu_template =  MenuTemplate.where(:vendor_id => @menu_template.vendor_id, 
                                                  :product_type => @menu_template.product_type,
                                                  :is_default => false ).first
        if other_menu_template
          other_menu_template.is_default = true
          other_menu_template.save
        end
      end

    
      @menu_template.destroy
      flash[:notice] = "Menu Template destroyed."
      redirect_to vendor_path(current_vendor, :selected => "menu_templates")
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying Menu Template - " + e.to_s
      redirect_to vendor_path(current_vendor, :selected => "menu_templates")
    end
  end

  # custom handlers
  # -----------------------------------

  def change_inventory_items
    @menu_template = MenuTemplate.find(params[:id])
    @menu_template_group = params[:menu_template_group_id] == "" ? nil : MenuTemplateGroup.find(params[:menu_template_group_id])

    params[:choices_to_select] = (defined?(params[:item_ids].count) ? params[:item_ids].count : 0) if (params[:choices_to_select].nil? || params[:choices_to_select].empty?)
    
    # First, update the attributes
    @menu_template_group.update_attributes!(:name => params[:name], :choices_to_select => params[:choices_to_select]) unless @menu_template_group.nil?

    # Next, update the inventory items associated with this group
    @menu_template.update_menu_template_group_inventory_items(@menu_template_group, params[:item_ids])

    respond_with(@menu_template, @menu_template_group, @available_items = InventoryItem.where(:vendor_id => @menu_template.vendor_id).all, @vendor = Vendor.find(@menu_template.vendor_id))
  end

  def create_menu_group
    @menu_template = MenuTemplate.find(params[:id])

    params[:choices_to_select] = (defined?(params[:item_ids].count) ? params[:item_ids].count : 0) if (params[:choices_to_select].nil? || params[:choices_to_select].empty?)

    # First, create the new menu template
    @menu_template_group = @menu_template.menu_template_groups.create!(:name => params[:name], :choices_to_select => params[:choices_to_select])

    # Next, update the inventory items associated with this group
    @menu_template.update_menu_template_group_inventory_items(@menu_template_group, params[:item_ids])
    
    flash[:notice] = "Menu Template Group added successfully"
    redirect_to edit_vendor_menu_template_path(current_vendor, @menu_template)
  end

  def delete_menu_group
    @menu_template = MenuTemplate.find(params[:id])
    @menu_template.menu_template_groups.destroy(@menu_template.menu_template_groups.where(:id => params[:menu_template_group_id]))
    @menu_template.menu_template_inventory_items.destroy(@menu_template.menu_template_inventory_items.where(:menu_template_group_id => params[:menu_template_group_id]))

    flash[:notice] = "Menu Template Group deleted successfully"
    redirect_to edit_vendor_menu_template_path(current_vendor, @menu_template)
  end

  def toggle_favorite
    @menu_template = MenuTemplate.find params[:id]
    unless current_user.favorite(MenuTemplate).include? @menu_template
      @menu_template.add_or_update_evaluation(:favorite, 1, current_user)
      alert = {
        :toggle_status => true
      }
    else
      @menu_template.delete_evaluation(:favorite, current_user)
      alert = {
        :toggle_status => false
      }
    end
    # Delete the cache entry...
    cid = 'User_' + current_user.id.to_s + '_Favorite_' + MenuTemplate.name
    Rails.cache.delete(cid)
    
    # And increment the counter!
    favorites_counter_cid = cid + '_cc'
    favorites_counter = -1
    if Rails.cache.exist?(favorites_counter_cid)
      favorites_counter = Rails.cache.read(favorites_counter_cid)
    end
    Rails.cache.write(favorites_counter_cid, favorites_counter + 1, expires_in: 1.week)
    render json: alert
  end

  # helper methods
  # -----------------------------------

  protected

    def menu_templates
      @menu_templates ||= current_vendor.menu_templates
    end

    def current_vendor
      @vendor ||= Vendor.find(params[:vendor_id])
    end

    def find_inventory_items vendor_id, product_type
      InventoryItem.where(:vendor_id => vendor_id).find_all{|item| item.inventory_item_product_types.where(:product_type => product_type).count > 0 && !item.inventory_item_option?}
    end

end