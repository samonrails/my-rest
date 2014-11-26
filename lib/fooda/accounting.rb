module Fooda
  module Accounting
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_payable options={}
        has_many :line_items, :as => :payable_party
      end

      def acts_as_billable options={}
        has_many :line_items, :as => :billable_party
      end
    end
  end
end