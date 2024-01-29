class CreateFinanceCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :finance_categories do |t|
      t.string :name,                                        null: false,                  limit: 20
      t.text :description,                                   null: false, default: "",     limit: 200 
      t.boolean :is_recurring,                               null: false, default: false
      t.enum :category_type, values: ['expense', 'income'],  null: false, default: 'expense', enum_type: :varchar

      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
