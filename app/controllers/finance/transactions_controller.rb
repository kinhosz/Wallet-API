class Finance::TransactionsController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  def create
    transaction = current_user.finance_transactions.new(
      occurred_at: transaction_params[:occurred_at],
      description: transaction_params[:description],
      value: transaction_params[:value],
      currency: transaction_params[:currency]
    )

    category = current_user.finance_categories.find_by(
      uuid: transaction_params[:category]
    )

    if category.nil?
      transaction.errors.add(:category, "Category not found")
      return render json: transaction.errors, status: :unprocessable_entity
    end

    transaction.finance_category = category

    if transaction.save
      render json: Finance::TransactionSerializer.new(
                    transaction
                  ).serializable_hash[:data][:attributes],
              status: :created
    else
      render json: transaction.errors, status: :unprocessable_entity
    end
  end

  def index
    transactions = current_user.finance_transactions
    render json: Finance::TransactionSerializer.new(
                  transactions
                ).serializable_hash[:data].map { |transaction| transaction[:attributes] }
  end

  def index_by_date
    transactions = current_user.finance_transactions
                               .where(
                                 currency: index_by_date_params[:currency],
                                 occurred_at: index_by_date_params[:date]
                               )
    render json: Finance::TransactionSerializer.new(
                  transactions
                ).serializable_hash[:data].map { |transaction| transaction[:attributes] }
  end

  def index_by_date_range
    transactions = current_user.finance_transactions
                               .where(
                                 currency: date_range_params[:currency],
                                 occurred_at: date_range_params[:start_date]..date_range_params[:end_date]
                               )
    render json: Finance::TransactionSerializer.new(
                  transactions
                ).serializable_hash[:data].map { |transaction| transaction[:attributes] }
  end

  private

  def index_by_date_params
    params.require(:currency)
    params.require(:date)
    params.permit(:currency, :date)
  end
  
  def date_range_params
    params.require(:currency)
    params.require(:start_date)
    params.require(:end_date)
    params.permit(:currency, :start_date, :end_date)
  end

  def transaction_params
    params.require(:transaction).permit(:occurred_at, :description, :value, :category, :currency)
  end
end
