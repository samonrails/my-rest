# == Schema Information
#
# Table name: voucher_groups
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :text
#  cogs_cents          :integer
#  quantity            :integer
#  event_id            :integer
#  order_id            :integer
#  line_item_id        :integer
#  voucher_template_id :integer
#  purcashed_by_id     :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  document_id         :integer
#

class VoucherGroup < ActiveRecord::Base
  belongs_to :event
  belongs_to :order
  belongs_to :voucher_template
  belongs_to :invoice, class_name: 'Document', foreign_key: 'document_id'
  belongs_to :purcahser, class_name: 'User', foreign_key: 'purcashed_by_id', validate: true
  has_one :document
  has_many :vouchers

  validates :voucher_template_id, :presence => true

  before_validation :template_setup
  after_create :create_vouchers, :generate_document

  monetize :cogs_cents 

  def total
    cogs * quantity
  end

  def expiration_date
    # Make an educated guess that the building of the event is the closet timezone to where the purchased vouchers. 
    timezone = event.try(:location).try(:building).try(:timezone)
    (timezone ? created_at.in_time_zone(timezone) : created_at) + 1.year
  end

  def account_name
    self.try(:event).account.name || ""
  end

  def create_vouchers
    (1..quantity).each { vouchers.create! }
  end

  def generate_document created_by=nil
    document = Document.create!(document_type: "Popup Vouchers: #{self.name}",
                                recipient:     event.account.name,
                                total:         total.to_s.to_i,
                                event_id:      event_id,
                                status:        DocumentStatus::requested,
                                name:          DocumentStatus::requested,
                                creator_id:    created_by)

    Sidekiq::Client.enqueue( VoucherDocumentJob, {:voucher_group_id => self.id, :document_id =>document.id} )
  end

  private
    def template_setup
      self.name ||= self.voucher_template.name
      self.description ||= self.voucher_template.description
      self.cogs_cents ||= self.voucher_template.cogs_cents
    end
end
