require "test_helper"

class Finance::PlanningsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    user = users(:one)
    sign_in user
  end

  teardown do
    sign_out :user
  end

  test "should not create planning when not logged in" do
    sign_out :user
    post finance_plannings_url, params: {
      planning: {
        date_start: "24-03-2024",
        date_end: "24-04-2024",
        lines: [
          value: 200.00,
          category: finance_categories(:credit_card).uuid
        ]
      }
    }

    assert_response :unauthorized
  end

  test "should create a category" do
    post(
      finance_plannings_url,
      params: {
        planning: {
          date_start: "24-03-2024",
          date_end: "24-04-2024",
          lines: [
            {
              value: 200.00,
              category: finance_categories(:credit_card).uuid
            }
          ]
        }
      }
    )
  
    assert_response :success
  end
end
