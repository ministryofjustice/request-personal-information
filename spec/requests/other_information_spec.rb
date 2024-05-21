require "rails_helper"

RSpec.describe "Which data is required", type: :request do
  describe "/moj" do
    let(:current_step) { "moj" }

    it_behaves_like "question that requires a session"

    context "when session in progress" do
      let(:information_request) { build(:information_request_for_self) }
      let(:previous_step) { "/subject-id-check" }
      let(:next_step) { "/prison-location" }
      let(:valid_data) { "no" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step:, history: [previous_step])
        get "/#{current_step}"
      end

      it "renders the choose other information page" do
        expect(response).to render_template(:show)
        expect(response.body).to include("Where do you want information from?")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { moj: [] } }
          expect(response).to render_template(:show)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Choose where you want information from")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { laa: "true" } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { laa: "true" } }
          expect(request.session[:information_request][:laa]).to eq true
        end
      end

      it_behaves_like "question with back link"
    end
  end
end
