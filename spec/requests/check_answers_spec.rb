require "rails_helper"

RSpec.describe "check answers", type: :request do
  let(:information_request) { build(:complete_request) }
  let(:previous_step) { "upcoming" }
  let(:current_step) { "check-answers" }

  it_behaves_like "question that requires a session"
  it_behaves_like "question that must be accessed in order"

  context "when session in progress" do
    before do
      set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
      get "/#{current_step}"
    end

    it "renders the expected page" do
      expect(response).to render_template(:show)
      expect(response.body).to include("Check your answers")
    end

    it "shows expected information" do
      expect(response.body).to include("Your details")
      expect(response.body).to include("Upload your ID")
      expect(response.body).to include("Where do you want information from?")
      expect(response.body).to include("HM Prison Service")
      expect(response.body).to include("Where we&#39;ll send the information")
    end

    it_behaves_like "question with back link"
  end
end
