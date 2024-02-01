require "test_helper"

class Finance::TransactionsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
        user = users(:one)
        sign_in user

        category = finance_categories(:credit_card)
        category.user = user
        category.save!

        @transaction = {
            transaction: {
                description: "credit card payment",
                occurred_at: Date.today,
                value: 200.00,
                category: finance_categories(:credit_card).uuid
            }
        }

        @invalid_transaction = {
            transaction: {
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
        
        assert_equal finance_categories(:credit_card).uuid,
            json_response[':category']
    end

    test "shoud not create a transaction without a valid category" do
        post finance_transactions_url, params: @invalid_transaction

        assert_response :unprocessable_entity
        
        json_response = JSON.parse(response.body)
        assert_includes json_response.keys, "category"
    end
end
