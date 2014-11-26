module Fooda
  module Asset
    extend ActiveSupport::Concern

    module ClassMethods
      def has_images options={}
        has_many :assets, :as => :owner, :dependent => :destroy
        accepts_nested_attributes_for :assets
      end
    end
  end
end