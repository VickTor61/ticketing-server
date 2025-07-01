class Ticket < ApplicationRecord
  belongs_to :customer, class_name: "User"
  has_many :comments, dependent: :destroy

  validate :must_be_customer
  enum :status, { open: 0, in_progress: 1, resolved: 2, closed: 3 }, default: :open

  enum :priority, { low: 0, medium: 1, high: 2, urgent: 3 }, default: :low

  scope :closed_last_month, -> { where(status: :closed, closed_at: 1.month.ago .. Time.current) }

  def customer_can_comment?
    comments.joins(:user).where(users: { role: "agent" }).exists?
  end

  def close!
    update!(status: :closed, closed_at: Time.current)
  end

  private

  def must_be_customer
    errors.add(:user, "must be a customer") unless customer&.customer?
  end
end
