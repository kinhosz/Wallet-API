class AddMixinAdjustmentsOnSchema < ActiveRecord::Migration[7.0]
  def change
    # Plannings
    add_column :finance_plannings, :uuid, :uuid, default: "gen_random_uuid()"
    reversible do |dir|
      dir.up do
        change_column :finance_plannings, :date_end, :date, null: true
      end

      dir.down do
        change_column :finance_plannings, :date_end, :date, null: false
      end
    end

    # Categories
    remove_column :finance_categories, :category_type, :string

    # Transactions
    add_column :finance_transactions, :currency, :string, null: false, default: "BRL"
  end
end
