require "test_helper"

class TicketTest < ActiveSupport::TestCase
  def setup
    @customer = users(:customer)
    @agent = users(:agent)
  end

  test "should be valid with a customer" do
    ticket = Ticket.new(title: "Test Ticket", description: "Test Description", customer: @customer)
    assert ticket.valid?
  end

  test "should be invalid without a customer" do
    ticket = Ticket.new(title: "Test Ticket", description: "Test Description")
    assert_not ticket.valid?
    assert_includes ticket.errors[:customer], "must exist"
  end

  test "should be invalid if user is not a customer" do
    ticket = Ticket.new(title: "Test Ticket", description: "Test Description", customer: @agent)
    assert_not ticket.valid?
    assert_includes ticket.errors[:user], "must be a customer"
  end

  test "should have a default status of open" do
    ticket = Ticket.new(title: "Test Ticket", description: "Test Description", customer: @customer)
    assert_equal "open", ticket.status
  end

  test "should have a default priority of low" do
    ticket = Ticket.new(title: "Test Ticket", description: "Test Description", customer: @customer)
    assert_equal "low", ticket.priority
  end

  test "#close! should update status to closed and set closed_at" do
    ticket = tickets(:one)
    ticket.close!
    assert_equal "closed", ticket.status
    assert_not_nil ticket.closed_at
  end

  test ".closed_last_month should return tickets closed in the last month" do
    ticket = tickets(:one)
    ticket.update!(status: :closed, closed_at: 2.weeks.ago)
    assert_includes Ticket.closed_last_month, ticket
  end

  test ".closed_last_month should not return tickets closed more than a month ago" do
    ticket = tickets(:one)
    ticket.update!(status: :closed, closed_at: 2.months.ago)
    assert_not_includes Ticket.closed_last_month, ticket
  end

  test "#customer_can_comment? should be true if an agent has commented" do
    ticket = tickets(:one)
    Comment.create!(content: "Agent comment", user: @agent, ticket: ticket)
    assert ticket.customer_can_comment?
  end

  test "#customer_can_comment? should be false if no agent has commented" do
    new_ticket = Ticket.create!(title: "New Ticket", description: "Description", customer: @customer)
    assert_not new_ticket.customer_can_comment?
  end
end