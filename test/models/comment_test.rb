require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @agent = users(:agent)
    @customer = users(:customer)
    @ticket = tickets(:one)
    @ticket.comments.delete_all
    @ticket.reload
    @ticket.association(:comments).reset
  end

  test "should be valid with content, user, and ticket" do
    comment = Comment.new(content: "This is a comment", user: @agent, ticket: @ticket)
    assert comment.valid?
  end

  test "should be invalid without content" do
    comment = Comment.new(user: @agent, ticket: @ticket)
    assert_not comment.valid?
    assert_includes comment.errors[:content], "can't be blank"
  end

  test "should be invalid without a user" do
    comment = Comment.new(content: "This is a comment", ticket: @ticket)
    assert_not comment.valid?
    assert_includes comment.errors[:user], "must exist"
  end

  test "should be invalid without a ticket" do
    comment = Comment.new(content: "This is a comment", user: @agent)
    assert_not comment.valid?
    assert_includes comment.errors[:ticket], "must exist"
  end

  test "content should not exceed 2000 characters" do
    comment = Comment.new(content: "a" * 2001, user: @agent, ticket: @ticket)
    assert_not comment.valid?
    assert_includes comment.errors[:content], "is too long (maximum is 2000 characters)"
  end

  test "customer can comment after an agent has commented" do
    Comment.create!(content: "Agent comment", user: @agent, ticket: @ticket)
    comment = Comment.new(content: "Customer comment", user: @customer, ticket: @ticket)
    assert comment.valid?
  end

  test "customer cannot comment before an agent has commented" do
    comment = Comment.new(content: "Customer comment", user: @customer, ticket: @ticket)
    assert_not comment.valid?
    assert_includes comment.errors[:user], "Cannot comment until an agent has commented on the ticket."
  end
end
