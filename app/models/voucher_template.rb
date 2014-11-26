# == Schema Information
#
# Table name: voucher_templates
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text
#  cogs_cents    :integer
#  line_item_sku :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class VoucherTemplate < ActiveRecord::Base

  monetize :cogs_cents 

end
