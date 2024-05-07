require "rails_helper"

RSpec.describe "Requester", type: :request do
  describe "/solicitor_details" do
    let(:current_step) { "solicitor-details" }

    context "when session not in progress" do
      it "redirects to the homepage" do
        get "/#{current_step}"
        expect(response).to redirect_to("/")
      end
    end

    context "when session in progress" do
      let(:information_request) { InformationRequest.new }
      let(:previous_step) { "/subject-relationship" }
      let(:next_step) { "/" }
      let(:valid_data) { "organisation name" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step:, history: [previous_step])
        get "/#{current_step}"
      end

      it "renders the solicitor details page" do
        expect(response).to render_template(:show)
        expect(response.body).to include("Your details")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { organisation_name: invalid_data } }
          expect(response).to render_template(:show)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Enter the name of your organisation")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { organisation_name: valid_data } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { organisation_name: valid_data } }
          expect(request.session[:information_request][:organisation_name]).to eq valid_data
        end
      end

      context "when going back" do
        it "goes to previous step" do
          get("/request/back")
          expect(response).to redirect_to(previous_step)
        end
      end
    end
  end
end
