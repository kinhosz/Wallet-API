class AddIndexToPlanningLines < ActiveRecord::Migration[6.0]
  def change
    add_index :finance_planning_lines,
              [:finance_planning_id, :finance_category_id],
              unique: true,
              name: 'index_planning_lines_on_planning_and_category'
  end
end
