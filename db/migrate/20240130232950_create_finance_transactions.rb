class CreateFinanceTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :finance_transactions do |t|
      t.text :description,     null: false, default: "",     limit: 30
      t.date :occurred_at,      null: false
      t.decimal :value,         null: false

      t.references :finance_category, foreign_key: true

      t.timestamps
    end
  end
end
