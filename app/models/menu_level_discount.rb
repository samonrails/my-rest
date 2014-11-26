# == Schema Information
#
# Table name: menu_level_discounts
#
#  id                 :integer          not null, primary key
#  min_participation  :integer
#  menu_template_id   :integer
#  event_vendor_id    :integer
#  cogs_cents         :integer
#  sell_price_cents   :integer
#  retail_price_cents :integer
#

class MenuLevelDiscount < ApplicationModel

  belongs_to :menu_template
  belongs_to :event_vendor

  default_scope order 'min_participation'

  validates :min_participation, :numericality => true
  validates :cogs_cents, :numericality => true
  validates :sell_price_cents, :numericality => true
  validates :retail_price_cents, :numericality => true

  validates_presence_of :min_participation
  validates_presence_of :cogs_cents
  validates_presence_of :sell_price_cents
  validates_presence_of :retail_price_cents

  monetize :cogs_cents
  monetize :sell_price_cents
  monetize :retail_price_cents

  after_initialize :initial_values

  public

    def to_s
      "MenuLevelDiscount"
    end

  private

    def initial_values
      self.cogs_cents  ||= 0
      self.sell_price_cents  ||= 0
      self.retail_price_cents  ||= 0
    end

end