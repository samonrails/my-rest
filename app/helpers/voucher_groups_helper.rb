module VoucherGroupsHelper
  # I can't get these to populate into my hand made HAML engine. :(

  def voucher_group_purcahse_date
    timezone = @voucher_group.event.try(:location).try(:building).try(:timezone)
    timezone ? @voucher_group.created_at.in_time_zone(timezone).strftime('%m/%d/%y') : @voucher_group.created_at.strftime('%m/%d/%y') 
  end

  def voucher_group_unit_price
    @voucher_group.cogs.to_s
  end
end