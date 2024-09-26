class AddUserIdToFinanceTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :finance_transactions, :user_id, :bigint
    add_index :finance_transactions, :user_id
    add_foreign_key :finance_transactions, :users, column: :user_id
  end
end