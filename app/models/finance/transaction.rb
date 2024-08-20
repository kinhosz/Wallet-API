class Finance::Transaction < ApplicationRecord
    validates :description, length: { maximum: 30 }
    validates :occurred_at, :description, :value, :finance_category_id, :currency, presence: true

    belongs_to :finance_category, class_name: "Finance::Category", dependent: :destroy
end
