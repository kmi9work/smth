require 'spec_helper'

describe "PasswordResets" do
  it "emails user when requesting password reset" do 
    user = create(:user)
    visit login_path
    click_link "Forgot your password?"
    fill_in "Email", :with => user.email
    click_button "reset"
    page.should have_content("You will receive an email with instructions about how to reset your password in a few minutes.")
  end
end