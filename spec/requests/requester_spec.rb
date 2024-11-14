require "rails_helper"

RSpec.describe "Requester", type: :request do
  describe "/solicitor-details" do
    let(:information_request) { build(:information_request_by_solicitor) }
    let(:current_step) { "solicitor-details" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "subject-relationship" }
      let(:next_step) { "/letter-of-consent" }
      let(:valid_data) { "organisation name" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("Your details")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { organisation_name: invalid_data } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Enter the name of your organisation")
        end
      end

      it_behaves_like "question that accepts valid data", :organisation_name
      it_behaves_like "question with back link"
    end
  end

  describe "/requester-details" do
    let(:information_request) { build(:information_request_for_other) }
    let(:current_step) { "requester-details" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "subject-relationship" }
      let(:next_step) { "/requester-id" }
      let(:valid_data) { "requester name" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("Your full name")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { requester_name: invalid_data } }
          expect(response).to render_template(:edit)
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

      it_behaves_like "question with back link"
    end
  end

  describe "/letter-of-consent" do
    let(:information_request) { build(:information_request_for_other) }
    let(:current_step) { "letter-of-consent" }
    let(:previous_step) { "requester-details" }
    let(:next_step) { "/letter-of-consent-check" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:valid_data) { fixture_file_upload("file.jpg") }
      let(:invalid_data) { nil }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("Upload a letter of consent")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { letter_of_consent: invalid_data } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Choose a file to upload")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { letter_of_consent: valid_data } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the associated ID to the session" do
          patch "/request", params: { request_form: { letter_of_consent: valid_data } }
          expect(request.session[:information_request][:letter_of_consent_id]).to be_an Integer
        end
      end

      it_behaves_like "question with back link"
    end

    context "when returning to page" do
      let(:letter_of_consent) { create(:attachment) }
      let(:information_request) { build(:information_request_for_other, letter_of_consent_id: letter_of_consent.id) }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "doesn't require repeat upload" do
        patch "/request", params: { request_form: { letter_of_consent_id: letter_of_consent.id } }
        expect(response).to redirect_to(next_step)
      end
    end
  end

  describe "/letter-of-consent-check" do
    let(:information_request) { build(:information_request_with_consent) }
    let(:current_step) { "letter-of-consent-check" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "letter-of-consent" }
      let(:next_step) { "/subject-id" }
      let(:valid_data) { "yes" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("Check your upload")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { letter_of_consent_check: invalid_data } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Enter an answer for is this upload is correct")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { letter_of_consent_check: valid_data } }
          expect(response).to redirect_to(next_step)
        end
      end

      context "when the user wants to change the upload" do
        it "goes to previous step" do
          patch "/request", params: { request_form: { letter_of_consent_check: "no" } }
          expect(response).to redirect_to("/#{previous_step}")
        end
      end

      it_behaves_like "question with back link"
    end
  end

  describe "/requester-id" do
    let(:information_request) { build(:information_request_for_other) }
    let(:current_step) { "requester-id" }
    let(:previous_step) { "letter-of-consent" }
    let(:next_step) { "/requester-address" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:valid_data) { fixture_file_upload("file.jpg") }
      let(:invalid_data) { nil }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("Upload your photo ID")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { requester_photo: invalid_data } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Upload your photo ID")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { requester_photo: valid_data } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the associated ID to the session" do
          patch "/request", params: { request_form: { requester_photo: valid_data } }
          expect(request.session[:information_request][:requester_photo_id]).to be_an Integer
        end
      end

      it_behaves_like "question with back link"
    end

    context "when returning to page" do
      let(:photo_upload) { create(:attachment) }
      let(:address_upload) { create(:attachment) }
      let(:information_request) { build(:information_request_by_friend, requester_photo_id: photo_upload.id) }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "doesn't require repeat upload" do
        patch "/request", params: { request_form: { requester_photo_id: photo_upload.id } }
        expect(response).to redirect_to(next_step)
      end
    end
  end

  describe "/requester-address" do
    let(:information_request) { build(:information_request_for_other) }
    let(:current_step) { "requester-address" }
    let(:previous_step) { "requester-id" }
    let(:next_step) { "/requester-id-check" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:valid_data) { fixture_file_upload("file.jpg") }
      let(:invalid_data) { nil }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("Upload your proof of address")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { requester_proof_of_address: invalid_data } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Upload your proof of address")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { requester_proof_of_address: valid_data } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the associated ID to the session" do
          patch "/request", params: { request_form: { requester_proof_of_address: valid_data } }
          expect(request.session[:information_request][:requester_proof_of_address_id]).to be_an Integer
        end
      end

      it_behaves_like "question with back link"
    end

    context "when returning to page" do
      let(:address_upload) { create(:attachment) }
      let(:information_request) { build(:information_request_by_friend, requester_proof_of_address_id: address_upload.id) }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "doesn't require repeat upload" do
        patch "/request", params: { request_form: { requester_proof_of_address_id: address_upload.id } }
        expect(response).to redirect_to(next_step)
      end
    end
  end

  describe "/requester-id-check" do
    let(:information_request) { build(:information_request_with_requester_id) }
    let(:current_step) { "requester-id-check" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "requester-id" }
      let(:next_step) { "/letter-of-consent" }
      let(:valid_data) { "yes" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("Check your upload")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { requester_id_check: invalid_data } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Enter an answer if these uploads are correct")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { requester_id_check: valid_data } }
          expect(response).to redirect_to(next_step)
        end
      end

      context "when the user wants to change the upload" do
        it "goes to previous step" do
          patch "/request", params: { request_form: { requester_id_check: "no" } }
          expect(response).to redirect_to("/#{previous_step}")
        end
      end

      it_behaves_like "question with back link"
    end
  end
end
