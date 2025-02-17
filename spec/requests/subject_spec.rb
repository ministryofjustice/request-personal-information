require "rails_helper"

RSpec.describe "Subject", type: :request do
  describe "#new" do
    it "redirects to the subject form" do
      get new_request_path
      expect(response).to redirect_to("/subject")
    end
  end

  describe "/subject" do
    let(:information_request) { InformationRequest.new }
    let(:current_step) { "subject" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "" }
      let(:next_step) { "/subject-name" }
      let(:valid_data) { "self" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it_behaves_like "question with a title", "Are you requesting your own information or someone else's?"

      it "renders the expected page" do
        expect(response).to render_template(:edit)
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { subject: invalid_data } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include(CGI.escapeHTML("Select if you are requesting your own information or someone else's"))
        end
      end

      it_behaves_like "question that accepts valid data", :subject
      it_behaves_like "question with back link"
    end
  end

  describe "/subject-name" do
    let(:information_request) { build(:information_request_for_self) }
    let(:current_step) { "subject-name" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "subject" }
      let(:next_step) { "/subject-date-of-birth" }
      let(:valid_data) { "subject name" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it_behaves_like "question with a title", "What is your name?"

      context "when requesting own data" do
        it "renders the expected page" do
          expect(response).to render_template(:edit)
        end

        context "when submitting form with invalid data" do
          it "renders page with error message" do
            patch "/request", params: { request_form: { full_name: invalid_data } }
            expect(response).to render_template(:edit)
            expect(response.body).to include("There is a problem")
            expect(response.body).to include("Enter your full name")
          end
        end

        it_behaves_like "question that accepts valid data", :full_name
        it_behaves_like "question with back link"
      end

      context "when requesting someone else's data" do
        let(:information_request) { build(:information_request_for_other) }

        it_behaves_like "question with a title", "What is their name?"

        it "renders the expected page" do
          expect(response).to render_template(:edit)
        end

        context "when submitting form with invalid data" do
          it "renders page with error message" do
            patch "/request", params: { request_form: { full_name: invalid_data } }
            expect(response).to render_template(:edit)
            expect(response.body).to include("There is a problem")
            expect(response.body).to include("Enter the full name of the person whose information you are requesting")
          end
        end
      end
    end
  end

  describe "/subject-date-of-birth" do
    let(:information_request) { build(:information_request_for_self) }
    let(:current_step) { "subject-date-of-birth" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "subject-name" }
      let(:next_step) { "/subject-id" }
      let(:invalid_data) { nil }
      let(:valid_data) { { "form_date_of_birth(3i)": "19", "form_date_of_birth(2i)": "5", "form_date_of_birth(1i)": "2007" } }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      context "when requesting own data" do
        it_behaves_like "question with a title", "What is your date of birth?"

        it "renders the expected page" do
          expect(response).to render_template(:edit)
        end

        context "when submitting form with invalid data" do
          it "renders page with error message" do
            patch "/request", params: { request_form: { form_date_of_birth: invalid_data } }
            expect(response).to render_template(:edit)
            expect(response.body).to include("There is a problem")
            expect(response.body).to include("Enter a date of birth")
          end
        end

        context "when submitting form with valid data" do
          it "goes to next step" do
            patch "/request", params: { request_form: valid_data }
            expect(response).to redirect_to(next_step)
          end

          it "saves the value to the session" do
            patch "/request", params: { request_form: valid_data }
            expect(request.session[:information_request][:date_of_birth]).to eq Date.new(2007, 5, 19)
          end
        end

        it_behaves_like "question with back link"
      end

      context "when requesting someone else's data" do
        let(:information_request) { build(:information_request_for_other) }

        it_behaves_like "question with a title", "What is their date of birth?"

        it "renders the expected page" do
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe "/subject-relationship" do
    let(:information_request) { build(:information_request_for_self) }
    let(:current_step) { "subject-relationship" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "subject-date-of-birth" }
      let(:next_step) { "/requester-details" }
      let(:valid_data) { "other" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      context "when requesting own data" do
        let(:next_step) { "/subject-id" }

        it "skips this page" do
          expect(response).to redirect_to(next_step)
        end
      end

      context "when requesting someone else's data" do
        let(:information_request) { build(:information_request_for_other) }

        it_behaves_like "question with a title", "What is your relationship to them?"

        it "renders the expected page" do
          expect(response).to render_template(:edit)
        end

        context "when submitting form with invalid data" do
          it "renders page with error message" do
            patch "/request", params: { request_form: { relationship: invalid_data } }
            expect(response).to render_template(:edit)
            expect(response.body).to include("There is a problem")
            expect(response.body).to include(CGI.escapeHTML("Select your relationship to the person whose information you are requesting"))
          end
        end

        it_behaves_like "question that accepts valid data", :relationship
        it_behaves_like "question with back link"
      end
    end
  end

  describe "/subject-id" do
    let(:information_request) { build(:information_request_for_other) }
    let(:current_step) { "subject-id" }
    let(:previous_step) { "requester-id" }
    let(:next_step) { "/subject-address" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:valid_data) { fixture_file_upload("file.jpg", "image/jpeg") }
      let(:invalid_data) { nil }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      context "when requesting data for someone else" do
        it_behaves_like "question with a title", "Upload photo ID of the person you are requesting information for"

        it "renders the expected page" do
          expect(response).to render_template(:edit)
          expect(response.body).to include("For example, a driving licence or passport")
        end
      end

      context "when requesting data for self" do
        let(:information_request) { build(:information_request_for_self) }

        it_behaves_like "question with a title", "Upload your photo ID"

        it "renders the expected page" do
          expect(response).to render_template(:edit)
          expect(response.body).to include("For example, a driving licence or passport. This can be a photograph, scan or photocopy of the original document.<br>Maximum size: 7 MB.")
        end
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { subject_photo: invalid_data } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Upload photo ID of the person you are requesting information for")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { subject_photo: valid_data } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the associated ID to the session" do
          patch "/request", params: { request_form: { subject_photo: valid_data } }
          expect(request.session[:information_request][:subject_photo_id]).to be_an Integer
        end
      end

      it_behaves_like "question with back link"
    end

    context "when returning to page" do
      let(:photo_upload) { create(:attachment) }
      let(:information_request) { build(:information_request_by_friend, subject_photo_id: photo_upload.id) }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "doesn't require repeat upload" do
        patch "/request", params: { request_form: { subject_photo_id: photo_upload.id } }
        expect(response).to redirect_to(next_step)
      end
    end
  end

  describe "/subject-address" do
    let(:information_request) { build(:information_request_for_other) }
    let(:current_step) { "subject-address" }
    let(:previous_step) { "subject-id" }
    let(:next_step) { "/subject-id-check" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:valid_data) { fixture_file_upload("file.jpg", "image/jpeg") }
      let(:invalid_data) { nil }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      context "when requesting data for someone else" do
        it_behaves_like "question with a title", "Upload proof of address of the person you are requesting information for"

        it "renders the expected page" do
          expect(response).to render_template(:edit)
          expect(response.body).to include("For example, an electricity or council tax bill")
        end
      end

      context "when requesting data for self" do
        let(:information_request) { build(:information_request_for_self) }

        it_behaves_like "question with a title", "Upload your proof of address"

        it "renders the expected page" do
          expect(response).to render_template(:edit)
          expect(response.body).to include("For example, an electricity or council tax bill")
        end
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { subject_proof_of_address: invalid_data } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Select a proof of address")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { subject_proof_of_address: valid_data } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the associated ID to the session" do
          patch "/request", params: { request_form: { subject_proof_of_address: valid_data } }
          expect(request.session[:information_request][:subject_proof_of_address_id]).to be_an Integer
        end
      end

      it_behaves_like "question with back link"
    end

    context "when returning to page" do
      let(:address_upload) { create(:attachment) }
      let(:information_request) { build(:information_request_by_friend, subject_proof_of_address_id: address_upload.id) }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "doesn't require repeat upload" do
        patch "/request", params: { request_form: { subject_proof_of_address_id: address_upload.id } }
        expect(response).to redirect_to(next_step)
      end
    end
  end

  describe "/subject-id-check" do
    let(:information_request) { build(:information_request_with_subject_id) }
    let(:current_step) { "subject-id-check" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "subject-id" }
      let(:next_step) { "/moj" }
      let(:valid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it_behaves_like "question with a title", "Check your uploads"

      it "renders the expected page" do
        expect(response).to render_template(:edit)
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { default: valid_data } }
          expect(response).to redirect_to(next_step)
        end
      end

      it_behaves_like "question with back link"
    end
  end
end
