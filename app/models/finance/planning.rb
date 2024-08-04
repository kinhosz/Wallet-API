class Finance::Planning < ApplicationRecord
    validates :currency, :date_end, :date_start, presence: true

    belongs_to :user

    has_many :finance_planning_lines, class_name: "Finance::PlanningLine"
end
