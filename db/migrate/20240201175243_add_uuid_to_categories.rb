class AddUuidToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :finance_categories, :uuid, :uuid, default: "gen_random_uuid()"
  end
end
