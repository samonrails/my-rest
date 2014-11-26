class Admin::VouchersController < ApplicationController
  respond_to :html
  
  def index
    voucher_ids = params[:voucher][:ids].split("\r\n").each{|id| id.upcase!}
    @vouchers = Voucher.where(token: voucher_ids)
    @not_found = voucher_ids - @vouchers.map(&:token)
    @valid_vouchers = @vouchers.valid
    @expired_vouchers = @vouchers.expired
    @redeemed_vouchers = @vouchers.redeemed
    render partial: "admin/dashboard/voucher_lists"
  end

  def redeem_voucher
    @voucher = Voucher.find params[:id]
    @vouchers = Voucher.where(token: params[:redeem_voucher][:tokens])
    @valid_vouchers = @vouchers.valid
    @expired_vouchers = @vouchers.expired
    @redeemed_vouchers = @vouchers.redeemed
    @voucher.update_attributes(status: "redeemed", redeemed_by_id: current_user.id, redeemed_at: Time.now)
    render partial: "admin/dashboard/voucher_lists"
  end

  def redeem_all_vouchers
    @vouchers = Voucher.where(token: params[:redeem_voucher][:tokens])
    @valid_vouchers = @vouchers.valid
    @expired_vouchers = @vouchers.expired
    @redeemed_vouchers = @vouchers.redeemed
    @vouchers.each do |voucher|
      voucher.update_attributes(status: "redeemed", redeemed_by_id: current_user.id, redeemed_at: Time.now)
    end
    render partial: "admin/dashboard/voucher_lists", locals: {all_redeemed: "true"}
  end

end
