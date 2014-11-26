require 'spec_helper'

describe Admin::UsersController do

  before(:each) do
    sign_in_user
    @user ||= FactoryGirl.create :user
    request.env['HTTPS'] = 'on'
  end
  
  describe 'DELETE /admin/users/:id' do
    it 'should destroy a user record' do
      assert_difference 'User.count', -1 do
        request.env["HTTP_REFERER"] = root_url
        delete :destroy, :id => @user.id
      end
      expect_redirect_to root_url
      expect_success_message "User deleted."
    end
  end

  describe 'POST /admin/users' do
    it 'should create user ' do
      assert_difference 'User.count', 1 do
        request.env["HTTP_REFERER"] = admin_users_path
        first_name = Faker::Name.first_name
        post :create, :user => {:first_name => first_name, :last_name =>Faker::Name.last_name, :email => "#{first_name}#{rand(100000)}@fooda.com"}
      end
      expect_redirect_to admin_users_path
      expect_success_message "User created."
    end
  end

  describe 'PUT /admin/users/:id/change_password' do
    it 'should update user password' do
      request.env["HTTP_REFERER"] = edit_admin_user_path(@user)
      put :change_password, :id => @user.id, :current_password => @user.password, :user => {:password => "testingpass", :password_confirmation => "testingpass"}
      expect_redirect_to edit_admin_user_path(@user)
      expect_success_message "Your password has been reset"
    end

    it 'should not update user password' do
      request.env["HTTP_REFERER"] = edit_admin_user_path(@user)
      password = Faker::Lorem.word
      put :change_password, :id => @user.id, :current_password => Faker::Lorem.word, :user => {:password => password, :password_confirmation => password}
      expect_redirect_to edit_admin_user_path(@user)
      expect_alert_message "Please enter the correct password"
    end
  end

  describe 'UPDATE /admin/users/:id' do
    it 'should update a user record' do
      request.env["HTTP_REFERER"] = edit_admin_user_path(@user)
      put :update, :user => {:first_name => @user.first_name, :last_name => @user.last_name, :phone_number => "#{rand(10000000000)}"}, :id => @user.id
      expect_redirect_to edit_admin_user_path(@user)
      expect_success_message "Profile updated successfully"
    end
  end

  describe 'UPDATE /admin/user/:id/restore_user' do
    it 'should restore a user' do
      request.env["HTTP_REFERER"] = root_url
      delete :destroy, :id => @user.id
      expect_redirect_to root_url
      expect_success_message "User deleted."

      request.env["HTTP_REFERER"] = admin_users_path
      put :restore_user, :id => @user.id
      expect_redirect_to admin_users_path
      expect_success_message "User restored."
    end
  end

  describe 'GET /admin/users/:id/resend_welcome_email' do
    it 'should resend welcome email ' do
      request.env["HTTP_REFERER"] = admin_users_path
      get :resend_welcome_email, :id => @user.id
      expect_redirect_to admin_users_path
    end
  end
  
end