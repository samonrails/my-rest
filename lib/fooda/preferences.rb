module Fooda
  module Preferences
    module Account
      def self.available_values
        %w{cuisine vendor}
      end

      def self.cuisine
        "cuisine"
      end

      def self.vendor
        "vendor"
      end
    end

    module Vendor
      def self.available_values
        %w{account location}
      end

      def self.account
        "account"
      end

      def self.location
        "location"
      end
    end

    module Disposition
      def self.available_values
        %w{favorite do_not_schedule}
      end

      def self.do_not_schedule
        "do_not_schedule"
      end

      def self.favorite
        "favorite"
      end
    end
  end
end