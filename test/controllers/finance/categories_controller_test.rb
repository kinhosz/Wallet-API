require "test_helper"

class Finance::CategoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    user = users(:admin)
    sign_in user
  end

  teardown do
    sign_out :user
  end

  # ------------------------------
  # POST #upsert
  # ------------------------------
  test "should not create category when not logged in" do
    sign_out :user
    post upsert_finance_categories_path, params: {
      category: {
        name: "credit card",
        description: "credit card category",
        icon: 0,
      }
    }

    assert_response :unauthorized
  end

  test "should create a category" do
    post(
      upsert_finance_categories_path,
      params: {
        "category": {
          "name": "credit card",
          "description": "credit card category",
          "icon": 0,
        }
      }
    )

    assert_response :success
  end

  test "should update a category" do
    post(
      upsert_finance_categories_path,
      params: {
        "category": {
          "uuid": finance_categories(:transport).uuid,
          "name": 'Uber',
        }
      }
    )

    assert_response :success
    body = JSON.parse(response.body)

    assert_equal body['uuid'], finance_categories(:transport).uuid
    assert_equal body['icon'], finance_categories(:transport).icon
    assert_equal body['description'], finance_categories(:transport).description
    assert_equal body['name'], 'Uber'
  end

  test "should return unprocessable_entity" do
    post(
      upsert_finance_categories_path,
      params: {
        "category": {
          "name": "",
          "description": "",
          "icon": 0,
        }
      }
    )

    assert_response :unprocessable_entity
  end

  # ------------------------------
  # GET #index
  # ------------------------------
  test "should not get the current planning when not logged in" do
    sign_out :user
    get finance_categories_path
    assert_response :unauthorized
  end

  test "should get all categories" do
    get finance_categories_path
    assert_response :success
  
    body = JSON.parse(response.body)

    assert_equal 6, body.length, "Categories length should be 6"
  
    body.each do |category|
      case category["name"]
      when "Salary"
        assert_equal "Monthly salary", category["description"]
        assert_equal "e743ad2a-3515-47ae-a55f-a16295e5155e", category["uuid"]
        assert_equal 1, category["icon"]
      when "Payment"
        assert_equal "Payment", category["description"]
        assert_equal "572f21e1-1e16-4880-8e05-752ebb8ba178", category["uuid"]
        assert_equal 2, category["icon"]
      when "School"
        assert_equal "School expenses", category["description"]
        assert_equal "988b5b62-a4df-434b-a4df-7b85467aba9f", category["uuid"]
        assert_equal 0, category["icon"]
      when "Credit Card"
        assert_equal "Credit Card category", category["description"]
        assert_equal "e0b1e835-fe1f-456f-8724-01df5bb7aa1e", category["uuid"]
        assert_equal -1, category["icon"]
      when "Health"
        assert_equal "Health", category["description"]
        assert_equal "c70a4acf-2d76-4b68-9c0e-259d22bdd47d", category["uuid"]
        assert_equal 3, category["icon"]
      when "Transport"
        assert_equal "Transport expenses", category["description"]
        assert_equal "95b71e8c-c27b-4485-9427-91aea94ae826", category["uuid"]
        assert_equal 6, category["icon"]
      else
        assert false, "Unexpected category: #{category['name']}"
      end
    end
  end  
end
