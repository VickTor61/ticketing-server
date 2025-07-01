require "test_helper"

class DailyReminderJobTest < ActiveJob::TestCase
  include ActiveJob::TestHelper
  include ActionMailer::TestHelper

  setup do
    @agent1 = users(:agent)
    @agent2 = users(:agent_two)
    @customer = users(:customer)
    @ticket1 = tickets(:one)
    @ticket2 = tickets(:two)
  end

  test "should enqueue daily reminder job" do
    assert_enqueued_with(job: DailyReminderJob) do
      DailyReminderJob.perform_later
    end
  end

  test "should send daily reminder to agents" do
    assert_emails User.agent.count do
      DailyReminderJob.perform_now
    end
  end

  test "should send correct open tickets in the email" do
    assert_emails User.agent.count do
      DailyReminderJob.perform_now
      mail = ActionMailer::Base.deliveries.last
      assert_equal "Open Support Tickets Reminder", mail.subject
      assert_includes User.agent.map(&:email), mail.to.first

      csv_attachment = mail.attachments.find { |a| a.filename == "open_tickets.csv" }
      assert_not_nil csv_attachment
      decoded_csv = csv_attachment.body.raw_source

      assert_match /ID,title,description,status,priority,creator,creator_id/, decoded_csv
      assert_match /#{@ticket1.id},#{@ticket1.title},#{@ticket1.description},#{@ticket1.status},#{@ticket1.priority},#{@customer.full_name},#{@customer.id}/, decoded_csv
      assert_match /#{@ticket2.id},#{@ticket2.title},#{@ticket2.description},#{@ticket2.status},#{@ticket2.priority},#{@customer.full_name},#{@customer.id}/, decoded_csv
    end
  end
end