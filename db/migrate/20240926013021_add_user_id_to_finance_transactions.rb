class AddUserIdToFinanceTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :finance_transactions, :user_id, :integer
    add_foreign_key :finance_transactions, :users
    add_index :finance_transactions, :user_id
  end
end