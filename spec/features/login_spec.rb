require 'spec_helper'

feature "Login" do
  let!(:user) { create(:user, :unconfirmed) }

  scenario "An unconfirmed user attempts to login" do
    visit "/login"
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'Welcome1'
    click_button "Sign in"
    expect(page).to have_text('Invalid email or password.')
  end

  scenario "Confirmed User Logs in" do
    user.confirm!
    visit "/login"
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'Welcome1'
    click_button "Sign in"
    expect(page).to have_text("Signed in successfully.")
  end

  scenario "Someone attempts to login with a utility account" do
    user.confirm!
    user.update_attribute(:utility_account, true)
    visit "/login"
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'Welcome1'
    click_button "Sign in"
    expect(page).to have_text('Your account was not activated yet')
  end
end
