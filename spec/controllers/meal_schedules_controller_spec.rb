require 'spec_helper'

describe MealSchedulesController do
  pending ("Sam learns how to set the current_user") do
  before { visit root_path }
  let(:user) { FactoryGirl.create(:user) }
  
  before do
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
 
 it "should render show page for empty meals" do
    user.meal = create(:meal)
    get :show, id: 4
    assert_response :success
    response.should render_template :show
  end
  end
end
