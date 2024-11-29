require "test_helper"

class Finance::TransactionsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
        user = users(:admin)
        sign_in user

        category = finance_categories(:credit_card)
        category.update(user: user)

        transaction_record = Finance::Transaction.create!(
            currency: "BRL",
            description: "credit card payment",
            occurred_at: Date.today,
            value: 200.00,
            user_id: user.id,
            finance_category: category
        )

        transaction_out_of_range = Finance::Transaction.create!(
            currency: "BRL",
            description: "Out of range transaction",
            occurred_at: Date.today - 10.days,
            value: 100.00,
            user_id: user.id,
            finance_category: category
        )

        transaction_in_range = Finance::Transaction.create!(
            currency: "BRL",
            description: "In range transaction",
            occurred_at: Date.today - 5.days,
            value: 150.00,
            user_id: user.id,
            finance_category: category
        )

        @user = user
        @category = category
        @transaction_record = transaction_record
        @transaction_out_of_range = transaction_out_of_range
        @transaction_in_range = transaction_in_range

        @transaction = {
            transaction: {
                currency: "BRL",
                description: "credit card payment",
                occurred_at: Date.today,
                value: 200.00,
                category: category.uuid
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
        transaction = @transaction[:transaction]

        assert_equal transaction[:description], json_response['description']
        assert_equal transaction[:occurred_at].strftime('%Y-%m-%d'), json_response['occurred_at']
        assert_equal transaction[:value], json_response['value'].to_f
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

    # ------------------------------
    # GET #index_by_date_range
    # ------------------------------

    test "should get index_by_date_range with valid start_date and end_date" do
        start_date = (Date.today - 7.days).strftime('%Y-%m-%d')
        end_date = Date.today.strftime('%Y-%m-%d')

        get filter_by_date_range_finance_transactions_url, params: { start_date: start_date, end_date: end_date }

        assert_response :success

        json_response = JSON.parse(response.body)
        assert json_response.is_a?(Array)

        json_response.each do |transaction|
            occurred_at = Date.parse(transaction['occurred_at'])
            assert occurred_at >= Date.parse(start_date)
            assert occurred_at <= Date.parse(end_date)
        end

        assert_includes json_response.map { |t| t['description'] }, @transaction_record.description
        assert_includes json_response.map { |t| t['description'] }, @transaction_in_range.description
        assert_not_includes json_response.map { |t| t['description'] }, @transaction_out_of_range.description
    end

    test "should get empty array for index_by_date_range when no transactions in range" do
        start_date = (Date.today - 20.days).strftime('%Y-%m-%d')
        end_date = (Date.today - 15.days).strftime('%Y-%m-%d')
    
        get filter_by_date_range_finance_transactions_url, params: { start_date: start_date, end_date: end_date }
    
        assert_response :success
    
        json_response = JSON.parse(response.body)
        assert json_response.is_a?(Array)
        assert json_response.empty?
    end
end
