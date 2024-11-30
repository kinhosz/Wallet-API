class Finance::TransactionsController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  def create
    transaction = Finance::Transaction.new(
      occurred_at: transaction_params[:occurred_at],
      description: transaction_params[:description],
      value: transaction_params[:value],
      currency: transaction_params[:currency],
      user_id: current_user.id
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
    transactions = Finance::Transaction.where(user_id: current_user.id)
    render json: Finance::TransactionSerializer.new(transactions).serializable_hash[:data].map { |transaction| transaction[:attributes] }
  end

  def index_by_date
    date = index_by_date_params[:date]
    transactions = current_user.finance_transactions(
      index_by_date_params[:currency]
    ).where(
      occurred_at: index_by_date_params[:date]
    )

    render json: Finance::TransactionSerializer.new(transactions).serializable_hash[:data].map { |transaction| transaction[:attributes] }
  end

  def index_by_date_range
    transactions = current_user.finance_transactions(
      date_range_params[:currency]
    ).where(
      occurred_at: date_range_params[:start_date]..date_range_params[:end_date]
    )

    render json: Finance::TransactionSerializer.new(transactions).serializable_hash[:data]
                                               .map { |transaction| transaction[:attributes] }
  end

  private

  def index_by_date_params
    params.permit(:date)
    params.require(:currency)

    {
      date: params[:date],
      currency: params[:currency]
    }
  end

  def date_range_params
    params.require(:start_date)
    params.require(:end_date)
    params.require(:currency)

    {
      start_date: params[:start_date],
      end_date: params[:end_date],
      currency: params[:currency]
    }
  end

  def transaction_params
    params.require(:transaction).permit(
      :occurred_at, :description, :value, :category, :currency)
  end
end
