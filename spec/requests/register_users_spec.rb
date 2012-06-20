require 'spec_helper'

describe "RegisterUser" do
  it "register user" do 
    visit register_path
    fill_in "Email", :with => "some@email.com"
    fill_in "Password", :with => "some_password"
    fill_in "confirmation", :with => "some_password"
    click_button "Sign up"
    page.should have_content("successfully")
  end
end