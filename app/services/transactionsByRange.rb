class TransactionsByRange
  def initialize(user, currency, start_date, end_date=nil)
    unless end_date
      end_date = Date.today
    end

    @user = user
    @currency = currency
    @start_date = start_date
    @end_date = end_date
  end

  def get_total_amount
    total = @user.finance_transactions.where(
      currency: @currency,
      occurred_at: @start_date..@end_date
    ).sum(:value)

    total.to_f
  end
end
