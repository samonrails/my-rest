module DocumentsHelper

  def market_info(event)
    market = event.location.building.market
    address = "#{market.address1} #{market.address2} #{market.city}, #{market.state}"
    phone = market.office_default_phone
    fax = market.office_default_fax
    return address, phone, fax
  end

end