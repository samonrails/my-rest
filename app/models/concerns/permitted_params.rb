class PermittedParams < Struct.new(:params, :user)

 # emails
  # ------------------------------
  def email
    params.require(:email).permit(*email_attributes)
  end

  def email_attributes
    [:email, :email_list]
  end

 # location
  # ------------------------------
  def location
    params.require(:location).permit(*location_attributes)
  end

  def location_attributes
    [:name, :location_type, :expected_participation, :privacy, :created_by_id,
      :service_event_instructions, :connectivity_instructions, :deleted_at,
      :delivery_event_instructions, :building_address_notes, :contact_id, :building_id,
      :account_id, :default_site_fee,
      assets_attributes: [:id, :description, :resource, :owner_type, :owner_id, :is_default] ]
  end

  # market
  # ------------------------------
  def market
    params.require(:market).permit(*market_attributes)
  end

  def market_attributes
    [:name, :default_tax_rate, :office_default_phone, :office_default_fax, 
     :office_default_sms, :office_default_email, :address1, :address2, :city, :state, :zip]
  end

  def event_schedule
    params.require(:event_schedule).permit(*event_schedule_attributes)
  end

  def event_schedule_attributes
    [:schedule, :contact_id, :created_by_id, :created_date, :event_end_time,
     :event_start_time, :inactive_until, :location_id, :meal_period, :product,
      :setup_end_time, :setup_start_time, :vendor_id, :schedule_start_date, 
      :schedule_end_date, :pause_start_date, :pause_end_date,:days_to_schedule,
      :menu_template_id, :quantity, :event_schedule_owner_id, :schedule_start_date,
      :schedule_end_date, :pause_start_date, :pause_end_date, :days_to_schedule]
  end

  # vendor product types
  # ------------------------------
  def vendor_product_type
    params.require(:vendor_product_type).permit(*vendor_product_type_attributes)
  end

  def vendor_product_type_attributes
    [:vendor_id, :product_type, :status]
  end

  # account pricing tiers
  # ------------------------------
  def account_pricing_tier
    params.require(:account_pricing_tier).permit(*account_pricing_tier_attributes)
  end

  def account_pricing_tier_attributes
    [:account_id, :product, :pricing_tier_id]
  end

  # contact
  # ------------------------------

  def contact
    params.require(:contact).permit(*contact_attributes)
  end

  def contact_attributes
    [:name, :position, :email, :phone_number, :mobile_number, :fax_number, :primary_contact, 
      :event_notifications, :billing_notifications, :sms, :feedback_notifications, :contact_type]
  end

  # building
  # ------------------------------
  
  def building
    params.require(:building).permit(*building_attributes)
  end

  def building_attributes
    [:name, :insurance_requirements, :insurance_required, 
      :parking_information, :loading_information, :site_directions, :market_id, 
      :contact_title, :contact_name, :contact_phone, :contact_cell, 
      :contact_fax, :contact_email, :address_id, :contact_id, :timezone, :is_approved, 
      address_attributes: [:id, :name, :address1, :address2, :city, 
      :state, :zip_code, :country],
      assets_attributes: [:id, :description, :resource, :owner_type, :owner_id, :is_default] ]
  end

  # event
  # ------------------------------
  def event
    params.require(:event).permit(*event_attributes)
  end

  def event_attributes
    [:name, :account_id, :quantity, :product, :menu_name, :meal_period,
      :status, :contact_id, :event_start_time, :event_end_time, :service_style,
      :setup_start_time, :setup_end_time, :individual_label, :utensils_plates_napkins, 
      :serving_utensils, :sternos, :chaffing_frames, :internal_event_notes, :cancellation_reason,
      :external_account_notes, :building_instructions, :location_instructions, :location_id,
      :created_by_id, :canceled_within_24_hours, :event_owner_id,
      event_vendors_attributes: [:id, :external_vendor_notes],
      event_reviews_attributes: [:id, :rating, :content, :rating_type],
      event_ratings_attributes: [:id, :rating, :reviewable_id, :reviewable_type, :contact_id, :additional_event_ratings]]
  end


  def event_transaction_method
    params.require(:event_transaction_method).permit(*event_transaction_method_attributes)
  end

  def event_transaction_method_attributes
    [:transaction_method, :info1, :info2, :transaction_card_token, :user_id, :party_type, :party_id]
  end


  # event_vendor
  # ------------------------------
  def event_vendor
    params.require(:event_vendor).permit!
  end

  # inventory_item
  # ------------------------------

  def inventory_item
    # params.require(:inventory_item).permit(*inventory_item_attributes)
    params.require(:inventory_item).permit!
  end

  def inventory_item_attributes
    [:name, :description, :cogs, :perks_price, :retail_price, :tag_list, :min_quantity,
      :option_list, :meal_type, :product_types_allowed, :inventory_item_option, :premium_price,
      :min_feeds, :max_feeds, :packaging_details, :eligible_for_add_ons,
      assets_attributes: [:id, :description, :resource, :owner_type, :owner_id, :is_default] ]
  end

  # menu
  # ------------------------------

  def menu
    params.require(:menu).permit(:name, :cogs, :sell_price, :pricing_type)
  end

  def menu_attributes
    if user && user.operations
      [:attr]
    else
      [:attr]
    end
  end

  # menu item
  # ------------------------------

  def menu_item
    params.require(:menu_item).permit(:featured, :sell_price, :inventory_item_id)
  end

  def menu_item_attributes
    if user && user.operations
      [:attr]
    else
      [:attr]
    end
  end


  # menu_template
  # ------------------------------

  def menu_template
    params.require(:menu_template).permit(:name, :pricing_type, :product_type, :min_quantity, :average_per_person_price,
      :expiration_date, :start_date, :cogs, :sell_price, :retail_price, :all_items, :is_eligible_for_self_service, 
      :description, :meal_period_list, :is_default, menu_level_discounts_attributes: [:id, :min_participation, :cogs, 
        :sell_price, :retail_price, :_destroy])
  end

  def menu_template_attributes
    if user && user.operations
      [:attr]
    else
      [:attr]
    end
  end

  # menu_template_inventory_item
  # ------------------------------

  def menu_template_inventory_item
    params.require(:menu_template_inventory_item).permit!
  end

  # menu_template_group
  # ------------------------------

  def menu_template_group
    params.require(:menu_template_group).permit!
  end

  # pricing_tier
  # ------------------------------

  def pricing_tier
    params.require(:pricing_tier).permit(:name, :gross_profit)
  end

  def pricing_tier_attributes
    if user && user.operations
      [:attr]
    else
      [:attr]
    end
  end

  # line_item
  # ------------------------------

  def line_item
    params.require(:line_item).permit!
  end

  # vendor
  # ------------------------------

  def vendor
    params.require(:vendor).permit!
  end

  def vendor_attributes
    [:name, :legal_name, :description, :website, :image_file_name, 
    :image_content_type, :image_file_size, :image_updated_at, :cuisine_list, :product_type_config,
    :default_tax_rate, :address, :vendor_manager_id, :vendor_minimum, :concurrent_orders,
    :concurrent_orders_time, :managed_services_lead_time, :vendor_type, :fee, :is_fixed, :cap, 
    address_attributes: [:id, :name, :address1, :address2, :city, :state, :zip_code, :country]]
  end

  # account
  # ------------------------------

  def account
    params.require(:account).permit(*account_attributes)
  end

  def account_attributes
    [:name, :website, :account_type, :active, :address_id, :image, 
    :account_exec_id, :sales_rep_id, :account_manager_id, :credit_status,
    :credit_limit, :net_days_for_full_payment, :buffer_days, :tax_exempt, :active_popup_vouchers,
    address_attributes: [:id, :name, :address1, :address2, :city, :state, 
    :zip_code, :country], account_email_lists_attributes: [:id, :account_id, :list_id]]
  end

  # menu_level_discounts
  # ------------------------------

  def menu_level_discount
    params.require(:menu_level_discount).permit(*menu_level_discount_attributes)
  end

  def menu_level_discount_attributes
    [:min_participation, :cogs, :sell_price, :event_id, :retail_price]
  end

  # billing_references
  # ------------------------------

  def billing_reference
    params.require(:billing_reference).permit(*billing_reference_attributes)
  end

  def billing_reference_attributes
    [:name, :tag_list, :data, :required]
  end

  # preferences
  # ------------------------------

  def account_preference
    params.require(:account_preference).permit(*account_preference_attributes)
  end

  def account_preference_attributes
    [:account_id, :vendor_id, :disposition, :preference_type, :cuisine]
  end

  def vendor_preference
    params.require(:vendor_preference).permit(*vendor_preference_attributes)
  end

  def vendor_preference_attributes
    [:account_id, :vendor_id, :disposition, :preference_type, :location_id]
  end

  # ssp_persistences
  # ------------------------------

  def ssp_persistence
    params.require(:ssp_persistence).permit(*ssp_persistence_attributes)
  end

  def ssp_persistence_attributes
    [:ssp_persistence_type, :name, :parameters]
  end

  # user
  # ------------------------------

  def user
    params.require(:user).permit(*user_attributes)
  end

  def user_attributes
    [:first_name, :last_name, :email, :password, :password_confirmation, :roles, :disable, :created_by, :phone_number, :position, :agreed_terms_at]
  end

 # issue
  # ------------------------------
  def issue
    params.require(:issue).permit(*issue_attributes)
  end

  def issue_attributes
    [:title, :description, :priority, :status, :assigner_id, :assignee_id, :subject_id,
    :subject_type, :due_date, :open_date]
  end

   # comment
  # ------------------------------
  def comment
    params.require(:comment).permit(*comment_attributes)
  end

  def comment_attributes
    [:issue_id, :user_id, :description]
  end

  # asset
  # ------------------------------
  def asset
    params.require(:asset).permit(*asset_attributes)
  end

  def asset_attributes
    [:description, :resource, :owner_type, :owner_id, :is_default]
  end

  # capacity
  # ------------------------------
  def capacity
    params.require(:capacity).permit(*capacity_attributes)
  end

  def capacity_attributes
    [:start_time, :end_time, :is_closed, :day]
  end

  # Account Role
  # ------------------------------
  def account_role
    params.require(:account_role).permit(*account_role_attributes)
  end

  def account_role_attributes
    [:user_id, :account_id, :role]
  end

  # building documents
  # ------------------------------
  def building_document
    params.require(:building_document).permit(*building_document_attributes)
  end

  def building_document_attributes
    [:document]
  end

  # location documents
  # ------------------------------
  def location_document
    params.require(:location_document).permit(*location_document_attributes)
  end

  def location_document_attributes
    [:document]
  end
  
  # select events
  # ----------------------------
  def select_event
    params.require(:select_event).permit(*select_event_attributes)
  end
  
  def select_event_attributes
    [:ready_and_bagged, :delivery_time, :ordering_window_start_time, :ordering_window_end_time, 
     :created_by_id, :delivery_fee_payer, :default_gratuity, :gratuity_payer, :tax_payer, :subsidy, 
     :subsidy_percentage_cap, :is_subsidy_percentage_capped, :subsidy_percentage_fixed_amount_cap, :subsidy_fixed_amount,
     :hide_gratuity_from_site, :hide_delivery_fee_from_site, :hide_tax_from_site, :account_id, :location_id, :contact_id,
     :meal_period, :event_owner_id, :status, :email_list_id, :introduction_email_time, :final_email_time, :user_contribution, :user_contribution_required]
  end
  
  # select event schedules
  def select_event_schedule
    params.require(:select_event_schedule).permit(*select_event_schedule_attributes)
  end
  
  def select_event_schedule_attributes
    [:ready_and_bagged, :delivery_time, :ordering_window_start_time, :ordering_window_end_time, 
     :created_by_id, :delivery_fee_payer, :default_gratuity, :gratuity_payer, :tax_payer, :subsidy, 
     :subsidy_percentage_cap, :is_subsidy_percentage_capped, :subsidy_percentage_fixed_amount_cap, :subsidy_fixed_amount,
     :hide_gratuity_from_site, :hide_delivery_fee_from_site, :hide_tax_from_site, :account_id, :location_id, :contact_id,
     :meal_period, :event_schedule_owner_id, :email_list_id, :introduction_email_time, :final_email_time, :user_contribution, :user_contribution_required,
     :schedule_start_date, :schedule_end_date, :pause_start_date, :pause_end_date, :days_to_schedule, :schedule]
  end
  
  # select_event_schedule_vendor
  def select_event_schedule_vendor
    params.require(:select_event_schedule_vendor).permit(*select_event_schedule_vendor_attributes)
  end
  
  def select_event_schedule_vendor_attributes
    [:account_id, :select_event_schedule_id, :vendor_id, :menu_template_id]
  end
  
  # Select event billing reference
  def select_event_billing_reference
    params.require(:select_event_billing_reference).permit(*select_event_billing_reference_attributes)
  end
  
  def select_event_billing_reference_attributes
    [:select_event_id, :billing_reference_id]
  end
  
  # Select event billing reference
  def select_event_schedule_billing_reference
    params.require(:select_event_schedule_billing_reference).permit(*select_event_schedule_billing_reference_attributes)
  end
  
  def select_event_schedule_billing_reference_attributes
    [:select_event_schedule_id, :billing_reference_id]
  end
  
  # zip codes
  def zip_code
    params.require(:zip_code).permit(*zipcode_attributes)
  end

  def zipcode_attributes
    [:zipcode]
  end
  
  # Select event campaign
  def select_event_campaign
    params.require(:select_event_campaign).permit(*select_event_campaign_attributes)
  end
  
  def select_event_campaign_attributes
    [:select_event_id, :state, :email_type, :campaign_id]
  end
  
  # select_event_schedule_vendor
  def select_event_vendor
    params.require(:select_event_vendor).permit(*select_event_vendor_attributes)
  end
  
  def select_event_vendor_attributes
    [:select_event_id, :vendor_id, :menu_template_id]
  end

  # Select order
  def select_order
    params.require(:select_order).permit(*select_order_attributes)
  end

  def select_order_attributes
    [:edit_mode, :status]
  end

  # Select Order Item
  def select_order_item
    params.require(:select_order_item).permit(*select_order_item_attributes)
  end

  def select_order_item_attributes
    [:id, :select_order_id, :vendor_id, :inventory_item_id, :quantity, :special_instructions, :status,
      select_order_item_options_attributes: [:id, :inventory_item_id, :option_group_id, :select_order_item_id] ]
  end

  # Select Order Transaction
  def select_order_transaction
    params.require(:select_order_transaction).permit(*select_order_transaction_attributes)
  end

  def select_order_transaction_attributes
    [:select_order_id, :card_id, :account_id, :amount, :notes,
     :is_refund, :select_order_transaction_id,
     :name, :number, :cvv, :expiration_month, :expiration_year,
     :address, :city, :state, :zipcode, :send_receipt]
  end

end

  
