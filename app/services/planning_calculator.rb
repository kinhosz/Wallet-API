class PlanningCalculator
  def initialize(planning)
    @planning = planning
    @date_start = @planning.date_start.strftime("%Y-%m-%d")
    @date_end = @planning.date_end.nil? ? Date.today.strftime("%Y-%m-%d") : @planning.date_end.strftime("%Y-%m-%d")

    set_categories
  end

  def compute
    {
      uuid: @planning.uuid,
      start_date: @date_start,
      end_date: @date_end,
      planning_lines: @planning_lines.map do |line|
        {
          category: {
            name: line[:name],
            description: line[:description],
            uuid: line[:uuid],
            icon: line[:icon],
          },
          planned: line[:planned].to_f,
          real: line[:real].to_f
        }
      end,
    }
  end

  def set_categories
    @planning_lines = @planning.finance_planning_lines.left_outer_joins(
      finance_category: :finance_transactions
    ).where(
      "(finance_transactions.occurred_at BETWEEN ? AND ? 
        AND finance_transactions.currency = ?
      ) OR finance_transactions.id IS NULL",
      @date_start,
      @date_end,
      @planning.currency
    ).group(
      'finance_categories.id, finance_planning_lines.value'
    ).select(
      'finance_categories.name AS name,
      finance_categories.description AS description,
      finance_categories.uuid AS uuid,
      finance_categories.icon AS icon,
      finance_planning_lines.value AS planned,
      COALESCE(SUM(finance_transactions.value), 0) AS real'
    )
  end
end
