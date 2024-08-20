class BalanceResume
  def initialize(categories, date_start, date_end, currency)
    @currency = currency
    @date_start = date_start.strftime("%Y-%m-%d")
    @date_end = date_end.nil? ? Date.today.strftime("%Y-%m-%d") : date_end.strftime("%Y-%m-%d")
    @categories = categories

    set_balance
  end

  def get
    {
      initial_balance: @balance.initial_balance.to_f,
      monthly_balance: @balance.monthly_balance.to_f,
    }
  end

  def set_balance
    query = <<-SQL
      SELECT 
        SUM(
          CASE WHEN finance_transactions.occurred_at < '#{@date_start}' 
          THEN finance_transactions.value ELSE 0 END
        ) AS initial_balance,
        SUM(
          CASE WHEN finance_transactions.occurred_at BETWEEN '#{@date_start}' AND '#{@date_end}' 
          THEN finance_transactions.value ELSE 0 END
        ) AS monthly_balance
      FROM finance_categories
      INNER JOIN finance_transactions ON finance_transactions.finance_category_id = finance_categories.id
      WHERE finance_transactions.currency = '#{@currency}'
    SQL

    @balance = Finance::Category.find_by_sql(query).first
  end
end
