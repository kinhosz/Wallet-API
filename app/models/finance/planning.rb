class Finance::Planning < ApplicationRecord
    validates :currency, :date_start, presence: true

    belongs_to :user

    has_many :finance_planning_lines, class_name: "Finance::PlanningLine", foreign_key: :finance_planning_id

    scope :by_currency, ->(currency) { where(currency: currency) }
end
