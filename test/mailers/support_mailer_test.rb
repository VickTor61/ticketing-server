require "test_helper"

class SupportMailerTest < ActionMailer::TestCase
  test "send_reminder_to_agent" do
    agent = users(:agent)
    csv_content = "id,title\n1,Test Ticket"

    email = SupportMailer.send_reminder_to_agent(agent, csv_content)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [agent.email], email.to
    assert_equal "Open Support Tickets Reminder", email.subject
    assert_equal ["support@example.com"], email.from
    assert_equal 1, email.attachments.size
    assert_equal "open_tickets.csv", email.attachments[0].filename
    assert_equal "text/csv", email.attachments[0].mime_type
    assert_equal csv_content.gsub("\n", "\r\n"), email.attachments[0].body.raw_source
  end
end