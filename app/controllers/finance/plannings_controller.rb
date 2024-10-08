class Finance::PlanningsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_currency_present, only: [:current]
  respond_to :json

  def create
    finance_planning = current_user.finance_plannings.build(
      currency: finance_planning_params[:currency],
      date_start: finance_planning_params[:date_start],
      date_end: finance_planning_params[:date_end]
    )

    if finance_planning.save
      unknown_categories = []
      finance_planning_params[:lines].each do |line|
        category = current_user.finance_categories.find_by(uuid: line[:category])
        if category
          Finance::PlanningLine.create(
            value: line[:value],
            finance_category: category,
            finance_planning: finance_planning
          )
        else
          unknown_categories << line[:category]
        end
      end

      serializable_planning = Finance::PlanningSerializer.new(
                                finance_planning.reload
                              ).serializable_hash[:data][:attributes]

      unless unknown_categories.size
        render json: serializable_planning, status: :created, location: finance_plannings_path
      else
        render json: serializable_planning, status: :created, location: finance_plannings_path, unknown_categories: unknown_categories
      end
    else
      render json: finance_planning.errors, status: :unprocessable_entity
    end
  end

  def current
    planning = current_user.finance_plannings(params[:currency]).last
    categories = current_user.finance_categories

    balance = BalanceResume.new(categories, planning.date_start, planning.date_end, params[:currency]).get
    computed = PlanningCalculator.new(planning).compute
    render json: computed.merge(balance)
  end

  private
  def finance_planning_params
    params.require(:planning).permit(:currency, :date_start, :date_end, lines: [:category, :value])
  end

  def ensure_currency_present
    unless params[:currency].present?
      render json: { error: "Currency parameter is required" }, status: :bad_request
    end
  end
end
