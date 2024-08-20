require "test_helper"

class Finance::CategoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    user = users(:one)
    sign_in user
  end

  teardown do
    sign_out :user
  end

  test "should not create category when not logged in" do
    sign_out :user
    post finance_categories_url, params: {
      category: {
        name: "credit card",
        description: "credit card category",
      }
    }

    assert_response :unauthorized
  end

  test "should create a category" do
    post(
      finance_categories_url,
      params: {
        "category": {
          "name": "credit card",
          "description": "credit card category",
        }
      }
    )

    assert_response :success
  end

  test "should return unprocessable_entity" do
    post(
      finance_categories_url,
      params: {
        "category": {
          "name": "",
          "description": "",
        }
      }
    )

    assert_response :unprocessable_entity
  end
end
