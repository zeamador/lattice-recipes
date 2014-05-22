require 'spec_helper'

describe "User pages" do
    subject { page }
    
    describe "signup page" do
      before { visit signup_path }
      
      it { should have_content('Sign up') }
      it { should have_title('Sign up') }
    end
    
    #describe "signup" do
      
    #  before { visit signup_path }
      
    #  let(:submit) { "Create Account" }
      
      #describe "with invalid information" do
        
      #  before do
      #    fill_in "Name",         with: "ExampleUser"
      #    fill_in "Email Address",        with: "user@example.com"
      #    fill_in "New Password",     with: ""
      #    fill_in "Confirm Password", with: ""
      #  end
        
      #  it "should not create a user" do
      #    expect { click_button submit }.not_to change(User, :count)
      #  end
      #end
      
      #describe "with valid information" do
      #  before do
      #    fill_in "Name",         with: "ExampleUser"
      #    fill_in "Email Address",        with: "user@example.com"
      #    fill_in "Password",     with: "foobar"
      #    fill_in "Confirm Password", with: "foobar"
      #end
        
      #  it "should create a user" do
      #  expect { click_button submit }.to change(User, :count).by(1)
      #  end
      #end
    #end
    
    #describe "edit" do
    #  let(:user) { FactoryGirl.create(:user) }
      
    # before { visit edit_user_path(user) }
      
    #  describe "page" do
    #  it { should have_content("Change Password") }
        #      it { expect(title).to eq(edit_user_path(user)) }
    #    it { should have_title("User Settings") }
    #  end
      
    #  describe "with invalid information" do
    #    before { click_button "Change Password" }
        
    #    it { should have_content('error') }
    #  end
    #end
end
