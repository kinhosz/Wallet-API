class Finance::PlanningLine < ApplicationRecord
    validates :value, numericality: { greater_than_or_equal_to: 0.0 }
    validates :finance_category_id, :finance_planning_id, :value, presence: true

    belongs_to :finance_category, class_name: "Finance::Category"
    belongs_to :finance_planning, class_name: "Finance::Planning", foreign_key: "finance_planning_id"
end
