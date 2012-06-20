require 'spec_helper'

describe "LoginUsers" do
  it "login user" do 
    user = create(:user)
    visit login_path
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "foobar"
    click_button "Sign"
    page.should have_content("successfully")
  end
end
