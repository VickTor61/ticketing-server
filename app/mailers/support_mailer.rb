class SupportMailer < ApplicationMailer
  default from: "support@example.com"

  def send_reminder_to_agent(agent, csv_content)
    @user = agent
    attachments["open_tickets.csv"] = { mime_type: "text/csv", content: csv_content }
    mail to: @user.email, subject: "Open Support Tickets Reminder"
  end
end
