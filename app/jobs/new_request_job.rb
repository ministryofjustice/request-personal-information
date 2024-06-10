class NewRequestJob < ApplicationJob
  queue_as :default

  def perform(request)
    body = request.payload.to_json
    HTTParty.post(api_url, body:, headers: { "Content-Type" => "application/json" })
    request.update!(submitted_at: Time.current)

    if request.contact_email.present?
      NotifyMailer.new_request(request).deliver_now
    end
  end

private

  def api_url
    ENV["API_URL"] || "https://localhost"
  end
end
