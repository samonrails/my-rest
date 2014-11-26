# == Schema Information
#
# Table name: event_managed_services_rollups
#
#  id                               :integer          not null, primary key
#  revenue_cents                    :integer
#  cogs_cents                       :integer
#  delivery_charge_to_vendor_cents  :integer
#  total_billing_cents              :integer
#  total_tax_cents                  :integer
#  subtotal_cents                   :integer
#  gratuity_cents                   :integer
#  enterprise_fee_cents             :integer
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  delivery_charge_to_account_cents :integer
#  vouchers_purchased_cents         :integer
#

class EventManagedServicesRollup < ApplicationModel

  validates :revenue_cents, :presence => true, :numericality => true
  validates :cogs_cents, :presence => true, :numericality => true
  validates :delivery_charge_to_vendor_cents, :presence => true, :numericality => true
  validates :delivery_charge_to_account_cents, :presence => true, :numericality => true
  validates :total_billing_cents, :presence => true, :numericality => true
  validates :total_tax_cents, :presence => true, :numericality => true
  validates :subtotal_cents, :presence => true, :numericality => true
  validates :gratuity_cents, :presence => true, :numericality => true
  validates :enterprise_fee_cents, :presence => true, :numericality => true
  validates :vouchers_purchased_cents, :presence => true, :numericality => true

  monetize :revenue_cents
  monetize :cogs_cents
  monetize :delivery_charge_to_vendor_cents
  monetize :delivery_charge_to_account_cents
  monetize :total_billing_cents
  monetize :total_tax_cents
  monetize :subtotal_cents
  monetize :gratuity_cents
  monetize :enterprise_fee_cents
  monetize :vouchers_purchased_cents

  after_initialize :initial_values

  public

  private

    def initial_values
      self.revenue_cents ||= 0
      self.cogs_cents ||= 0
      self.delivery_charge_to_vendor_cents ||= 0
      self.delivery_charge_to_account_cents ||= 0
      self.total_billing_cents ||= 0
      self.total_tax_cents ||= 0
      self.subtotal_cents ||= 0
      self.gratuity_cents ||= 0
      self.enterprise_fee_cents ||= 0
      self.vouchers_purchased_cents ||= 0
    end

end
