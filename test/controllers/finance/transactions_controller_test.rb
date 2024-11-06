require "test_helper"

class Finance::TransactionsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
        user = users(:admin)
        sign_in user

        category = finance_categories(:credit_card)
        category.user = user
        category.save!

        @transaction = {
            transaction: {
                currency: "BRL",
                description: "credit card payment",
                occurred_at: Date.today,
                value: 200.00,
                category: finance_categories(:credit_card).uuid
            }
        }

        @invalid_transaction = {
            transaction: {
                currency: "BRL",
                description: "credit card payment",
                occurred_at: Date.today,
                value: 200.00,
                category: "invalid_uuid"
            }
        }
    end

    teardown do
        sign_out :user
    end

    test "should not create transaction when not logged in" do
        sign_out :user
        post finance_transactions_url, params: @transaction

        assert_response :unauthorized
    end

    test "shoud create a transaction" do
        post finance_transactions_url, params: @transaction

        assert_response :success

        json_response = JSON.parse(response.body)
        
        assert_equal @transaction[:transaction][:description],
            json_response['description']

        assert_equal @transaction[:transaction][:occurred_at].strftime('%Y-%m-%d'),
            json_response['occurred_at']
        
        assert_equal @transaction[:transaction][:value],
            json_response['value'].to_f
    end

    test "shoud not create a transaction without a valid category" do
        post finance_transactions_url, params: @invalid_transaction

        assert_response :unprocessable_entity
        
        json_response = JSON.parse(response.body)
        assert_includes json_response.keys, "category"
    end

    # ------------------------------
    # GET #index
    # ------------------------------

    test "should get index" do
        get finance_transactions_url
    
        assert_response :success
    
        json_response = JSON.parse(response.body)
        assert json_response.is_a?(Array)
        assert_not json_response.empty?
    
        assert_equal @transaction.description, json_response[0]['description']
        assert_equal @transaction.occurred_at.strftime('%Y-%m-%d'), json_response[0]['occurred_at']
        assert_equal @transaction.value.to_f, json_response[0]['value']
      end

    
    # ------------------------------
    # GET #index_by_date
    # ------------------------------

    test "should get index_by_date with specific date" do
        specific_date = Date.today.strftime('%Y-%m-%d')

        get filter_by_date_finance_transactions_url, params: { start_date: specific_date }

        assert_response :success

        json_response = JSON.parse(response.body)
        assert json_response.is_a?(Array)

        json_response.each do |transaction|
            assert_equal specific_date, transaction['occurred_at']
        end
    end
end
