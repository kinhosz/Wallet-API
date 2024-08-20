class Finance::Category < ApplicationRecord
    validates :name, length: { minimum: 1, maximum: 20 }
    validates :description, length: { maximum: 200 }
    validates :name, :user_id, presence: true

    belongs_to :user

    has_many :finance_transactions, class_name: "Finance::Transaction"
    has_many :finance_planning_line, class_name: "Finance::PlanningLine"
end
