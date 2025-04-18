require "test_helper"

class Finance::PlanningsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    user = users(:admin)
    sign_in user
  end

  teardown do
    sign_out :user
  end

  # ------------------------------
  # POST #create
  # ------------------------------
  test "should not create planning when not logged in" do
    sign_out :user
    post finance_plannings_url, params: {
      planning: {
        currency: "BRL",
        date_start: "24-03-2024",
        date_end: "24-04-2024",
        lines: [
          { value: 200.00, category: finance_categories(:credit_card).uuid }
        ]
      }
    }
    assert_response :unauthorized
  end

  test "should create a planning" do
    post(
      finance_plannings_url,
      params: {
        planning: {
          currency: "BRL",
          date_start: "24-03-2024",
          date_end: "24-04-2024",
          lines: [
            { value: 200.00, category: finance_categories(:credit_card).uuid }
          ]
        }
      }
    )
  
    assert_response :success
  end

  # ------------------------------
  # GET #show
  # ------------------------------
  test "should not get the planning when not logged in" do
    sign_out :user
    uuid = finance_plannings(:current_brl).uuid
    get finance_planning_path(uuid)
    assert_response :unauthorized
  end

  test "should return a bad request for missing currency" do
    get finance_planning_path(finance_plannings(:current_brl).uuid)
    assert_response :bad_request
    json_response = JSON.parse(response.body)
    assert_equal "Currency parameter is required", json_response["error"]
  end

  test "should get the last open planning for BRL when using current" do
    last_open_planning = finance_plannings(:current_brl)
    get finance_planning_path("current"), params: {currency: "BRL"}
    assert_response :success
    assert_equal last_open_planning.uuid, response.parsed_body["uuid"]
  end

  test "should get the planning for BRL with valid UUID" do
    uuid = finance_plannings(:current_brl).uuid
    get finance_planning_path(uuid), params: { currency: "BRL" }
    assert_response :success

    body = JSON.parse(response.body)
    assert_equal 708.00, body["initial_balance"], "initial balance"
    assert_equal 2327.00, body["monthly_balance"], "monthly balance"

    body["planning_lines"].each do |item|
      if item["category"]["name"] == finance_categories(:credit_card).name
        assert_equal finance_planning_lines(:current_credit_card_brl).value, item["planned"]
        assert_equal finance_transactions(:credit_card_brl_01).value, item["real"]
      elsif item["category"]["name"] == finance_categories(:school).name
        assert_equal finance_planning_lines(:current_school_brl).value, item["planned"]
        assert_equal finance_transactions(:school_brl_00).value, item["real"]
      elsif item["category"]["name"] == finance_categories(:salary).name
        assert_equal finance_planning_lines(:current_salary_brl).value, item["planned"]
        assert_equal finance_transactions(:salary_brl_01).value, item["real"]
      else
        assert false, "Value not mapped"
      end
    end
  end

  # ------------------------------
  # GET #index
  # ------------------------------
  test "index should not get plannings when not logged in" do
    sign_out :user
    get finance_plannings_path, params: { currency: "BRL" }
    assert_response :unauthorized
  end

  test "index should return a bad request for missing currency" do
    get finance_plannings_path
    assert_response :bad_request
    json_response = JSON.parse(response.body)
    assert_equal "Currency parameter is required", json_response["error"]
  end

  test "should return plannings for a given currency" do
    get finance_plannings_path, params: { currency: "BRL" }
    assert_response :success

    body = JSON.parse(response.body)
    assert_equal 2, body['plannings'].length(), "There are 2 plannings for BRL"

    body['plannings'].each do |planning|
      if planning['uuid'] == finance_plannings(:current_brl).uuid
        assert_equal finance_plannings(:current_brl).date_start.strftime('%Y-%m-%d'), planning['start_date']
        assert_equal 'current', planning['end_date']
        assert_equal 2327.00, planning['balance']
      elsif planning['uuid'] == finance_plannings(:previous_brl).uuid
        assert_equal finance_plannings(:previous_brl).date_start.strftime('%Y-%m-%d'), planning['start_date']
        assert_equal finance_plannings(:previous_brl).date_end.strftime('%Y-%m-%d'), planning['end_date']
        assert_equal 708.00, planning['balance']
      else
        assert false, "Unknown planning uuid: #{planning['uuid']}"
      end
    end
  end

  # ------------------------------
  # POST #upsert_line
  # ------------------------------
  test "should add a finance planning line" do
    planning = finance_plannings(:current_brl)
    assert_difference('Finance::PlanningLine.count', 1) do
      post upsert_line_finance_planning_path(planning.uuid),
        params: {
          planning_line: {
            category: finance_categories(:transport).uuid,
            value: 100
          }
        }
    end
    assert_response :created
  end

  test "should update the line" do
    planning = finance_plannings(:current_brl)
    assert_no_difference('Finance::PlanningLine.count') do
      post upsert_line_finance_planning_path(planning.uuid),
        params: {
          planning_line: {
            category: finance_categories(:credit_card).uuid,
            value: 150
          }
        }
    end
    assert_response :success
  end
end
