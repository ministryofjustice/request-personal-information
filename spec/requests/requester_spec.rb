require "rails_helper"

RSpec.describe "Requester", type: :request do
  describe "/solicitor-details" do
    let(:current_step) { "solicitor-details" }

    context "when session not in progress" do
      it "redirects to the homepage" do
        get "/#{current_step}"
        expect(response).to redirect_to("/")
      end
    end

    context "when session in progress" do
      let(:information_request) { InformationRequest.new(subject: "other", relationship: "legal_representative") }
      let(:previous_step) { "/subject-relationship" }
      let(:next_step) { "/requester-details" }
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

  describe "/requester-details" do
    let(:current_step) { "requester-details" }

    context "when session not in progress" do
      it "redirects to the homepage" do
        get "/#{current_step}"
        expect(response).to redirect_to("/")
      end
    end

    context "when session in progress" do
      let(:information_request) { InformationRequest.new(subject: "other", relationship: "other") }
      let(:previous_step) { "/subject-relationship" }
      let(:next_step) { "/letter-of-consent" }
      let(:valid_data) { "requester name" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step:, history: [previous_step])
        get "/#{current_step}"
      end

      it "renders the requester details page" do
        expect(response).to render_template(:show)
        expect(response.body).to include("Your details")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { requester_name: invalid_data } }
          expect(response).to render_template(:show)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Enter your full name")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { requester_name: valid_data } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { requester_name: valid_data } }
          expect(request.session[:information_request][:requester_name]).to eq valid_data
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

  describe "/letter-of-consent" do
    let(:current_step) { "letter-of-consent" }

    context "when session not in progress" do
      it "redirects to the homepage" do
        get "/#{current_step}"
        expect(response).to redirect_to("/")
      end
    end

    context "when session in progress" do
      let(:information_request) { InformationRequest.new(subject: "other", relationship: "other") }
      let(:previous_step) { "/requester-details" }
      let(:next_step) { "/" }
      let(:valid_data) { fixture_file_upload("file.jpg") }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step:, history: [previous_step])
        get "/#{current_step}"
      end

      it "renders the requester details page" do
        expect(response).to render_template(:show)
        expect(response.body).to include("Upload a letter of consent")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { letter_of_consent: invalid_data } }
          expect(response).to render_template(:show)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Choose a file to upload")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { letter_of_consent: valid_data } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { letter_of_consent: valid_data } }
          expect(request.session[:information_request][:letter_of_consent]).to be_a ActionDispatch::Http::UploadedFile
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
