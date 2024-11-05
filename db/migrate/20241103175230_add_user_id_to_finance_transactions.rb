class AddUserIdToFinanceTransactions < ActiveRecord::Migration[7.0]
  def change
    add_reference :finance_transactions, :user, null: false, foreign_key: true
  end
end
