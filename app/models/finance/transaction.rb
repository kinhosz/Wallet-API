class Finance::Transaction < ApplicationRecord
    validates :description, length: { maximum: 30 }
    validates :occurred_at, :description, :value, :finance_category_id, :currency, presence: true

    belongs_to :finance_category, class_name: "Finance::Category", foreign_key: "finance_category_id", dependent: :destroy

    scope :by_currency, ->(currency) { where(currency: currency) }
end
