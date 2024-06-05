require "rails_helper"

RSpec.describe "submissions", type: :request do
  describe "create request" do
    let(:information_request) { build(:complete_request) }

    before do
      set_session(information_request: information_request.to_hash, current_step: "check-answers", history: %w[check-answers])
    end

    it "stores the information request" do
      expect {
        post "/request"
      }.to(change(InformationRequest, :count).by(1))
    end

    it "createa a job" do
      post "/request"
      expect(NewRequestJob).to have_been_enqueued
    end

    it "redirects to the form sent page" do
      post "/request"
      expect(response).to redirect_to("/form-sent")
    end

    context "when request is not valid" do
      let(:information_request) { build(:information_request_for_self) }

      it "redirects to the first question" do
        post "/request"
        expect(response).to redirect_to("/subject")
      end
    end
  end

  describe "form sent", type: :request do
    before do
      get "/form-sent"
    end

    it "renders the expected page" do
      expect(response).to render_template(:complete)
      expect(response.body).to include("Request sent")
    end
  end
end
