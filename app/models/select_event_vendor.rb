# == Schema Information
#
# Table name: select_event_vendors
#
#  id                             :integer          not null, primary key
#  select_event_id                :integer
#  vendor_id                      :integer
#  menu_template_id               :integer
#  vendor_billing_summary_sent_at :datetime
#

class SelectEventVendor < ActiveRecord::Base
  after_commit :reindex_es_async

  belongs_to :select_event
  belongs_to :vendor
  belongs_to :menu_template
  
  def reindex_es_async
    Elasticsearch.reindex "SelectEvent", self.select_event_id
  end

end

