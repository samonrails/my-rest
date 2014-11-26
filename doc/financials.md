### Model snippets (for reference)

```haml
class Event < ActiveRecord::Base
  has_many :line_items
  has_many :event_vendors
end

class EventVendor < ActiveRecord::Base
  belongs_to :event
  belongs_to :vendor
  belongs_to :menu_template
  has_many :menu_level_discounts
end

class LineItem < ActiveRecord::Base
  belongs_to :event
  belongs_to :inventory_item

  belongs_to :payable_party, :polymorphic => true
  belongs_to :billable_party, :polymorphic => true
end

class Vendor < ActiveRecord::Base
  include Fooda::Accounting
  acts_as_payable
  acts_as_billable
end

class Account < ActiveRecord::Base
  include Fooda::Accounting
  acts_as_payable
  acts_as_billable
end
```

### Line Item Schema (for reference)

```haml

# == Schema Information

# Table name: line_items

#  id                       :integer          not null, primary key
#  line_item_type           :string(255)
#  sku                      :string(255)
#  name                     :string(255)
#  notes                    :string(255)
#  quantity                 :integer

#  unit_price_expense       :decimal(, )
#  unit_price_revenue       :decimal(, )
#  include_price_in_expense :boolean
#  include_price_in_revenue :boolean

#  event_id                 :integer
#  inventory_item_id        :integer

#  billable_party_type      :string(255)
#  billable_party_id        :integer
#  payable_party_type       :string(255)
#  payable_party_id         :integer

#  tax_rate_expense         :decimal(, )
#  tax_rate_revenue         :decimal(, )

```
### Descriptions

- Types of line items: Goods, Service, Credit, Tax
  - Service, Credit, Tax: one sided line items - only have a payable party or billable party
  - Goods: two sided line items - have both a payable party and billable party

- Tax rate
  - Null tax rates are okay.  If null, the event-default-tax-rate will be used.
  - Items of type "Tax" are never taxed.

- Goods line items creation
  - When a menu_template is chosen, a "Goods" line item is created for each inventory item in the
    menu_template.  The unit_price_expense is taken from the COGS field in the inventory item,
    and the unit_price_revenue is calculated using the appropriate account pricing tier.  The billable party
    is the Account, and the payable party is the vendor of the menu_template.  The inventory_item_id field
    of the line item is set.
  - When a menu_template is chosen with menu-level pricing, a Goods line item that is a "Per Person Charge" will
    be created.  The unit_price_expense and unit_price_revenue will be calculated using menu-level pricing (taking
    into consideration event participation), along with the appropriate account pricing tier.  The billable party
    is the Account, and the payable party is the vendor of the menu_template.

- Service, Credit, Tax line items creation
  - Done via the financials page

- Goods per-person-charge line items creation
  - Done via the financials page

- Goods menu-item line items creation
  - Done via the menu page by creating menu items

- "include price"
  - Some line items need to go on the documents, but are not actually part of the pricing (catering food items, for example)
    For these items, the include_price_in_revenue/include_price_in_expense fields are set to false.

- Menu
  - Line Items that are of type "Goods", that have an associated inventory item

- Revenue/Expense "by party"
  - Helper methods in the Event model.
  - Fooda Revenue = sum(items where party is billable) - sum(items where party is payable)
  - Fooda Expense = sum(items where party is payable) - sum(items where party is billable)

