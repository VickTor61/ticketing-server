class ExportClosedTicketsService
  require "csv"

  def self.call

    tickets = Ticket.closed_last_month
                    .includes(:customer, :comments)
                    .select(:id, :title, :description, :customer_id, :created_at, :closed_at)

    csv_content = CSV.generate(headers: true) do |csv|
      csv << %w[id title description customer date_closed date_created comments_count]

      tickets.each do |ticket|
        csv << [
          ticket.id,
          ticket.title,
          ticket.description,
          ticket.customer.full_name,
          ticket.created_at.strftime("%b %d, %Y"),
          ticket.closed_at.strftime("%b %d, %Y"),
          ticket.comments.size
        ]
      end
    end
    csv_content
  end
end
