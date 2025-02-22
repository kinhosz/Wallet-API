class Finance::PlanningsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_currency_present, only: [:current, :index]
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

  def index
    plannings = current_user.finance_plannings(params[:currency])
    response = { plannings: [] }
    plannings.each do |planning|
      response[:plannings] << {
        uuid: planning.uuid,
        start_date: planning.date_start,
        end_date: planning.date_end ? planning.date_end : 'current',
        balance: TransactionsByRange.new(
          current_user, planning.currency, planning.date_start, planning.date_end
        ).get_total_amount
      }
    end

    render json: response
  end

  def upsert_line
    finance_planning = current_user.finance_plannings.find_by!(uuid: params[:id])
    category = current_user.finance_categories.find_by!(uuid: line_params[:category])
    line = finance_planning.finance_planning_lines.find_by(finance_category_id: category.id)

    if line
      update_line(line, line_params[:value])
    else
      create_line(finance_planning, category, line_params[:value])
    end
  end

  private

  def line_params
    params.require(:planning_line).permit(:category, :value)
  end

  def finance_planning_params
    params.require(:planning).permit(:currency, :date_start, :date_end, lines: [:category, :value])
  end

  def ensure_currency_present
    unless params[:currency].present?
      render json: { error: "Currency parameter is required" }, status: :bad_request
    end
  end

  def upsert_render(line, success)
    if success
      serializable_line = Finance::PlanningLineSerializer.new(
                            line.reload
                          ).serializable_hash[:data][:attributes]
      render json: serializable_line, status: :created
    else
      render json: { success: false, errors: line.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_line(line, value)
    upsert_render(line, line.update(value: value))
  end

  def create_line(planning, category, value)
    line = planning.finance_planning_lines.new(
      finance_category_id: category.id, value: value
    )
    upsert_render(line, line.save)
  end
end
