class UpdateAllVendorsFinancialProduct < ActiveRecord::Migration
  def up

    Vendor.all.map do |vendor|
      if vendor.products.where(product: Product.financial_m_s).nil?
        vendor.products.create(product: Product.financial_m_s, product_type: ProductType.managed_services)
      end
    end
  end

  def down
  end
end
