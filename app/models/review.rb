# == Schema Information
#
# Table name: reviews
#
#  id                       :integer          not null, primary key
#  reviewable_id            :integer
#  reviewable_type          :string(255)
#  contact_id               :integer
#  rating                   :integer
#  content                  :text
#  event_id                 :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  rating_type              :string(255)
#  additional_event_ratings :string(255)
#

class Review < ApplicationModel

  belongs_to :reviewable, polymorphic: true, dependent: :destroy
  belongs_to :contact
  belongs_to :event, foreign_key: 'reviewable_id', class_name: 'Event'
  belongs_to :event, foreign_key: 'event_id', class_name: 'Event'
  has_and_belongs_to_many :vendors
  
  validates_uniqueness_of :reviewable_id, scope: [:event_id, :additional_event_ratings, :reviewable_type, :contact_id], message: "Contact can rate an entity only once"

  after_create :distribute_rating_to_vendors

  private
    
    def distribute_rating_to_vendors
      if self.additional_event_ratings == "On Time Delivery"
        eligible_vendors = self.reviewable.vendors.select{|v| v.vendor_type == "Delivery Service"}
        if eligible_vendors.any?
          self.vendors << eligible_vendors
        else
          self.vendors << self.reviewable.vendors
        end
      end
    end
end
