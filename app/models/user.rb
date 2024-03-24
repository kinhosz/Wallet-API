class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  
  has_many :finance_categories, class_name: "Finance::Category", dependent: :destroy
  has_many :finance_planning, class_name: "Finance::Planning", dependent: :destroy
end
