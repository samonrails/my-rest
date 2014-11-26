module VendorsHelper
  
  def vendor_contacts
    @vendor.contacts.with_deleted.sort_by{|c| c.name}
  end

end