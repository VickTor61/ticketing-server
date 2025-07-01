class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :ticket

  validates :content, presence: true, length: { minimum: 1, maximum: 2000 }
  validate :customer_can_comment, if: -> { user&.customer? }

  private

  def customer_can_comment
    unless ticket.customer_can_comment?
      errors.add(:user, "Cannot comment until an agent has commented on the ticket.")
    end
  end
end
