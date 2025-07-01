class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::JTIMatcher

  has_many :blogs, dependent: :destroy
  has_many :tickets, foreign_key: :customer_id, dependent: :destroy
  has_many :comments, dependent: :destroy
  enum :role, { customer: 0, agent: 1 }, default: :customer

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_confirmation, presence: true, if: :password_required?

  normalizes :email, with: -> { _1.strip.downcase }

  def full_name
    "#{first_name} #{last_name}"
  end

  def generate_token
    payload = { user_id: id, jti: jti }
    JWT.encode(payload, Rails.application.credentials.devise_jwt_secret_key!)
  end
end
