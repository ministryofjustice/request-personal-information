class NewRequestJob < ApplicationJob
  queue_as :default

  def perform(request)
    Faraday.post(ENV["API_URL"], request.serialize)
    request.update!(submitted_at: Date.current)
  end
end
