class NewRequestJob < ApplicationJob
  queue_as :default

  def perform(request)
    url = ENV["API_URL"] || "https://qa.track-a-query.service.justice.gov.uk/api/rpi/v2"
    body = request.payload.to_json
    HTTParty.post(url, body:, headers: { "Content-Type" => "application/json" })
    request.update!(submitted_at: Date.current)
  end
end
