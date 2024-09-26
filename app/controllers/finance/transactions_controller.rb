class Finance::TransactionsController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  def index
    transactions = Finance::Transaction.joins(:finance_category)
                                       .where(finance_categories: { user_id: current_user.id })

    render json: Finance::TransactionSerializer.new(transactions).serializable_hash[:data].map { |transaction| transaction[:attributes] }
  end

  def index_by_date
    transactions = Finance::Transaction.joins(:finance_category)
                                       .where(finance_categories: { user_id: current_user.id })
  
    if params[:start_date].present? && params[:end_date].present?
      transactions = transactions.where(occurred_at: params[:start_date]..params[:end_date])
    elsif params[:start_date].present?
      transactions = transactions.where(occurred_at: params[:start_date])
    elsif params[:end_date].present?
      transactions = transactions.where('occurred_at <= ?', params[:end_date])
    end
  
    render json: Finance::TransactionSerializer.new(transactions).serializable_hash[:data].map { |transaction| transaction[:attributes] }
  end

  def create
    category = current_user.finance_categories.find_by(uuid: transaction_params[:category])

    if category.nil?
      return render json: { error: "Category not found" }, status: :unprocessable_entity
    end

    transaction = category.finance_transactions.build(transaction_params.except(:category).merge(finance_category_id: category.id))

    if transaction.save
      render json: Finance::TransactionSerializer.new(
                    transaction
                  ).serializable_hash[:data][:attributes],
              status: :created
    else
      render json: transaction.errors, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(
      :occurred_at, :description, :value, :category
    )
  end
end
