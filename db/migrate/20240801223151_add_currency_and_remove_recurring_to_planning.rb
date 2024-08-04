class AddCurrencyAndRemoveRecurringToPlanning < ActiveRecord::Migration[7.0]
  def change
    add_column :finance_plannings, :currency, :string, null: false, default: "BRL"
    remove_column :finance_categories, :is_recurring, :boolean
  end
end
