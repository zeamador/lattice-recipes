require 'spec_helper'

describe MealsController do
  it "should render show page" do
    meal = create(:meal)
    get :show, id: meal.id
    assert_response :success
    response.should render_template :show
  end
end
