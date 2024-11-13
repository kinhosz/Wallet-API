require "test_helper"

class Finance::TransactionsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
        @user = users(:admin)
        sign_in @user

        @category = finance_categories(:credit_card)
        @category.update(user: @user)

        @transaction_record = Finance::Transaction.create!(
        currency: "BRL",
        description: "credit card payment",
        occurred_at: Date.today,
        value: 200.00,
        user_id: @user.id,
        finance_category: @category
        )

        @transaction = {
        transaction: {
            currency: "BRL",
            description: "credit card payment",
            occurred_at: Date.today,
            value: 200.00,
            category: @category.uuid
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

    test "should create a transaction" do
        post finance_transactions_url, params: @transaction

        assert_response :success

        json_response = JSON.parse(response.body)
        
        assert_equal @transaction[:transaction][:description], json_response['description']
        assert_equal @transaction[:transaction][:occurred_at].strftime('%Y-%m-%d'), json_response['occurred_at']
        assert_equal @transaction[:transaction][:value], json_response['value'].to_f
    end

    test "should not create a transaction without a valid category" do
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

        # Comparação usando @transaction_record criado no setup
        assert_equal @transaction_record.description, json_response[0]['description']
        assert_equal @transaction_record.occurred_at.strftime('%Y-%m-%d'), json_response[0]['occurred_at']
        assert_equal @transaction_record.value.to_f, json_response[0]['value'].to_f
    end

    # ------------------------------
    # GET #index_by_date
    # ------------------------------

    test "should get index_by_date with specific date" do
        specific_date = Date.today.strftime('%Y-%m-%d')

        get filter_by_date_finance_transactions_url, params: { date: specific_date }

        assert_response :success

        json_response = JSON.parse(response.body)
        assert json_response.is_a?(Array)

        json_response.each do |transaction|
        assert_equal specific_date, transaction['occurred_at']
        end
    end
    end
