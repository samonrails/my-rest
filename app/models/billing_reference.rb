# == Schema Information
#
# Table name: billing_references
#
#  id         :integer          not null, primary key
#  account_id :integer
#  name       :string(255)
#  event_id   :integer
#  required   :boolean          default(FALSE)
#  data       :text
#  deleted_at :datetime
#

class BillingReference < ApplicationModel
  belongs_to :account
  belongs_to :event

  validates_presence_of :name
  acts_as_taggable
  acts_as_paranoid

  serialize :data, Array

  def self.as_tag_list_with_name
    scoped.inject({}) do |memo,billing_reference|
      memo[billing_reference.name] = billing_reference[:data]
      memo
    end
  end

  def data=(value)
    write_attribute(:data, value.split("\r\n"))
  end

  def data
    self[:data].join("\r\n")
  end
  
  def humanized_data
    self[:data].join(', ')
  end
end
