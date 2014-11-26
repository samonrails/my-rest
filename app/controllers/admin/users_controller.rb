class Admin::UsersController < ApplicationController
  respond_to :html

  def create
    authorize! :create, :user
    @user = User.new(permitted_params.user)
    @user.admin_build params[:user][:roles]
    if @user.save
      @user.admin_save(Account.find_all_by_name(params[:user][:accounts]), params[:send_email].nil?)
      flash[:notice] = "User created."
    else
      flash[:error] = "Error creating user - " + @user.errors.full_messages.join(", ")
    end
    redirect_to :back
  end

  def index
    authorize! :index, :user
    options = {:artificial_attributes => {"account"=>"accounts.name", "name" => "last_name"}}
    respond_to do |format|
      format.html do
        if params[:xls]
          redirect_to :action => "index", :format => "xls", :searchable => params[:searchable], :direction => params[:direction], :sort => params[:sort]
        else
          @users = Kaminari.paginate_array(User.includes(:accounts).search_sort_paginate(params, options)).page(params[:active_users]).per(50)
          @inactive_users = Kaminari.paginate_array(User.only_deleted).page(params[:inactive_users]).per(50)
        end
      end
      format.xls do
        @users = User.includes(:accounts).search_sort_paginate(params, options)
        headers["Content-Disposition"] = "attachment; filename=\"users.xls\""
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    authorize! :update, :user
    @user = User.find(params[:id])
    @user.skip_reconfirmation!

    if @user.update_attributes(permitted_params.user)
      flash[:notice] = 'Profile updated successfully'
    else
      flash[:error] = "Error updating profile - " + @user.errors.full_messages.join(", ")
    end
    redirect_to :back
  end

  def destroy
    authorize! :destroy, :user
    @user = User.find(params[:id])

    if @user.destroy
      flash[:notice] = "User deleted."
      redirect_to :back
    else
      flash[:notice] = "Error deleting user."
      redirect_to :back
    end
  end
  
  # CUSTOM ACTIONS: Passwords

  # With an email
  def password_reset
    user = User.find(params[:id])
    user.send_reset_password_instructions("true")
    redirect_to :back
  end

  def change_password
    authorize! :change_password, :user
    @user = User.find(params[:id])
    if @user.valid_password?(params[:current_password])
      if @user.update_attributes(permitted_params.user)
        flash[:notice] = "Your password has been reset"
        redirect_to :back
        sign_in(@user, :bypass => true)
      else
        flash[:error] = "Error updating password - " + @user.errors.full_messages.join(", ")
        redirect_to :back
      end
    else
      flash[:alert] = "Please enter the correct password"
      redirect_to :back
    end
  end

  # CUSTOM ACTIONS: user upload

  def csv_upload
    authorize! :csv_upload, :user
    begin
      associated_accounts = Account.find_all_by_name(params[:csv][:accounts])
      created, failed = User.import(params[:csv][:file], !params[:send_email].nil?, associated_accounts, params[:csv][:roles])
      flash[:notice] = "#{created} #{"user".pluralize(created)} created " if created > 0 
      flash[:error] = "Failed to create #{failed} #{"user".pluralize(failed)}. Please check your CSV." if failed > 0
    rescue 
      flash[:error] = "Faield to create users. Please check your CSV format."
    end
    redirect_to :back
  end

  # CUSTOM ACTIONS: Reviews

  def export_reviews
    authorize! :export_reviews, :user
    respond_to do |format|
      format.xls do
        @events = Event.select{|e| Product.find_parent(e.product) == params[:product_type]}
        @reviews = @events.map(&:event_ratings).flatten.select{|e| e.additional_event_ratings == params[:event_review_type]}
        if params[:rating] and !params[:rating].blank?
          @reviews = @reviews.select{|review| review.rating == params[:rating].to_i}
        end
        @event_review_type = params[:event_review_type]
        @product_type = params[:product_type]
        headers["Content-Disposition"] = "attachment; filename=\"reviews_for_#{params[:event_review_type]}.xls\""
      end
    end
  end

  def export_bar_graph_data
    authorize! :export_reviews, :user
    respond_to do |format|
      format.xls do
        @events = Event.select{|e| Product.find_parent(e.product) == params[:product_type]}
        @event_review_type = params[:event_review_type]
        @product_type = params[:product_type]
        headers["Content-Disposition"] = "attachment; filename=\"bar_graph_reviews.xls\""
      end
    end
  end

  def restore_user
    user = User.only_deleted.where(id: params[:id]).first
    if user.update_attributes(deleted_at: nil)
      flash[:notice] = "User restored."
      redirect_to :back
    else
      flash[:error] = "Error restoring user."
      redirect_to :back
    end
  end

  def resend_welcome_email
    user = User.find(params[:id])
    user.password = (0...8).map{(65+rand(26)).chr}.join
    temporary_password = user.password
    user.reset_password_token = User.reset_password_token
    user.reset_password_sent_at = Time.now
    user.save
    Sidekiq::Client.enqueue(MailScheduler, user.id, temporary_password, "Force Send")
    redirect_to :back
  end
end
