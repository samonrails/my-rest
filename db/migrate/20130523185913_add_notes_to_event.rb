class AddNotesToEvent < ActiveRecord::Migration
  def change
    add_column :events, :service_style, :string

    add_column :events, :individual_label, :boolean
    add_column :events, :utensils_plates_napkins, :boolean
    add_column :events, :serving_utensils, :boolean
    add_column :events, :sternos, :boolean
    add_column :events, :chaffing_frames, :boolean
    
    add_column :events, :internal_event_notes, :text
    add_column :events, :external_account_notes, :text
    add_column :events, :building_instructions, :text
    add_column :events, :location_instructions, :text

    add_column :event_vendors, :external_vendor_notes, :text 
  end
end
