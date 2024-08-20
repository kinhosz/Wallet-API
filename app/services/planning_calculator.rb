class PlanningCalculator
  def initialize(planning)
    @planning = planning
    @date_start = @planning.date_start.strftime("%Y-%m-%d")
    @date_end = @planning.date_end.nil? ? Date.today.strftime("%Y-%m-%d") : @planning.date_end.strftime("%Y-%m-%d")

    set_categories
  end

  def compute
    {
      start_date: @date_start,
      end_date: @date_end,
      categories: @categories_list.map do |category|
        {
          title: category[:title],
          planned: category[:planned].to_f,
          real: category[:real].to_f
        }
      end,
    }
  end

  def set_categories
    @categories_list = @planning.finance_planning_lines.left_outer_joins(
      finance_category: :finance_transactions
    ).where(
      finance_categories: { finance_transactions: { occurred_at: @date_start..@date_end, currency: @planning.currency } }
    ).group(
      'finance_categories.id, finance_planning_lines.value'
    ).select(
      'finance_categories.name AS title,
      finance_planning_lines.value AS planned,
      SUM(finance_transactions.value) AS real'
    )
  end
end
