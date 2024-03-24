class CreateFinancePlannings < ActiveRecord::Migration[7.0]
  def change
    create_table :finance_plannings do |t|
      t.date :date_start, null: false
      t.date :date_end,   null: false

      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
