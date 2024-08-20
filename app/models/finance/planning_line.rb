class Finance::PlanningLine < ApplicationRecord
    validates :finance_category_id, :finance_planning_id, :value, presence: true

    belongs_to :finance_category, class_name: "Finance::Category", foreign_key: "finance_category_id"
    belongs_to :finance_planning, class_name: "Finance::Planning", foreign_key: "finance_planning_id"
end
