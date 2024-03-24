class CreateFinancePlanningLines < ActiveRecord::Migration[7.0]
  def change
    create_table :finance_planning_lines do |t|
      t.decimal :value

      t.references :finance_planning, foreign_key: true
      t.references :finance_category, foreign_key: true

      t.timestamps
    end
  end
end
