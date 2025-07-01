class DailyReminderJob < ApplicationJob
  require "csv"
  queue_as :default

  def perform
    agents = User.agent
    open_tickets = Ticket.where(status: [:open, :in_progress]).includes(:customer)

    open_tickets_file = CSV.generate(headers: true) do |csv|
      csv << %w[ID title description status priority creator creator_id]

      open_tickets.each do |ticket|
        csv << [ticket.id, ticket.title, ticket.description, ticket.status, ticket.priority, ticket.customer.full_name, ticket.customer.id]
      end
    end

    agents.each do |agent|
      SupportMailer.send_reminder_to_agent(agent, open_tickets_file).deliver_later
    end
  end
end
