class Finance::TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_planning, only: [:index]
  respond_to :json

  def create
    transaction = Finance::Transaction.new(
      occurred_at: transaction_params[:occurred_at],
      description: transaction_params[:description],
      value: transaction_params[:value]
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
    transactions_service = TransactionsByDateService.new(current_user)
    serialized_transactions = transactions_service.map do |transaction|
      Finance::TransactionSerializer.new(transaction).serializable_hash[:data][:attributes]
    end

    render json: serialized_transactions, status: :ok
  end

  private

  def transaction_params
    params.require(:transaction).permit(
      :occurred_at, :description, :value, :category)
  end

  def set_planning
    @planning = current_user.finance_planning.find_by(uuid: params[:planning_id])
  end
end
