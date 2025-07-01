require "test_helper"

class Mutations::ExportClosedTicketsTest < ActiveSupport::TestCase
  def setup
    @agent = users(:agent)
    @customer = users(:customer)
    @close_ticket = tickets(:one).update!(status: :closed)
    tickets(:two).update!(status: :closed)
    @schema = TicketingSchema
  end

  test "should export closed tickets for agent user" do
    query = <<~GQL
      mutation ExportClosedTickets {
        closedTickets {
          content
          filename
          contentType
        }
      }
    GQL


    result = @schema.execute(query,  context: { current_user: @agent })
    assert_nil result["errors"]
    closed_tickets = result.to_h.dig("data", "closedTickets")
    refute_nil closed_tickets
  end
end
