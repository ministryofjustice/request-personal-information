require "rails_helper"

RSpec.describe NewRequestJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later(information_request) }

  let(:expected_payload) { { submission_id: "12345" } }
  let(:expected_headers) { { "Content-Type" => "application/json" } }
  let(:response) { instance_double(HTTParty::Response) }
  let(:information_request) { create(:complete_request) }

  before do
    allow_any_instance_of(InformationRequest).to receive(:payload) { expected_payload } # rubocop:disable RSpec/AnyInstance
    allow(HTTParty).to receive(:post).and_return(response)
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it "sends payload to RPI API" do
    expect(HTTParty).to receive(:post).with("https://localhost", body: expected_payload.to_json, headers: expected_headers)
    perform_enqueued_jobs { job }
  end

  it "updates submitted_at date on information request" do
    perform_enqueued_jobs { job }
    expect(information_request.reload.submitted_at).to be_within(5.seconds).of(Time.current)
  end

  it "sends an email if email is provided" do
    expect(NotifyMailer).to receive(:new_request).with(information_request).and_call_original
    perform_enqueued_jobs { job }
  end
end
