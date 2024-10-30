class AddIconToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :finance_categories, :icon, :integer, default: -1
  end
end
