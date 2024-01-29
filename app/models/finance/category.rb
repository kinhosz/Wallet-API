class Finance::Category < ApplicationRecord
    validates :category_type, inclusion: { in: %w(expense income) }
    validates :name, length: { minimum: 1, maximum: 20 }
    validates :description, length: { maximum: 200 }
    validates :name, :category_type, :user_id, presence: true

    belongs_to :user
end
