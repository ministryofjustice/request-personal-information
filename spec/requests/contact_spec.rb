require "rails_helper"

RSpec.describe "contact information", type: :request do
  describe "/contact-address" do
    let(:current_step) { "contact-address" }

    it_behaves_like "question that requires a session"

    context "when session in progress" do
      let(:information_request) { build(:information_request_for_laa) }
      let(:previous_step) { "/other-dates" }
      let(:next_step) { "/contact-email" }
      let(:valid_data) { "address details" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step:, history: [previous_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("send the information")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { contact_address: invalid_data } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Enter your address")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { contact_address: valid_data } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { contact_address: valid_data } }
          expect(request.session[:information_request][:contact_address]).to eq valid_data
        end
      end

      it_behaves_like "question with back link"
    end
  end

  describe "/contact-email" do
    let(:current_step) { "contact-email" }

    it_behaves_like "question that requires a session"

    context "when session in progress" do
      let(:information_request) { build(:information_request_for_laa) }
      let(:previous_step) { "/contact-address" }
      let(:next_step) { "/upcoming" }
      let(:valid_data) { "email@domain.com" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step:, history: [previous_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("Your email")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { contact_email: invalid_data } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Enter your email")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { contact_email: valid_data } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { contact_email: valid_data } }
          expect(request.session[:information_request][:contact_email]).to eq valid_data
        end
      end

      it_behaves_like "question with back link"
    end
  end

  describe "/upcoming" do
    let(:current_step) { "upcoming" }

    it_behaves_like "question that requires a session"

    context "when session in progress" do
      let(:information_request) { build(:information_request_for_laa) }
      let(:previous_step) { "/contact-email" }
      let(:next_step) { "/" }
      let(:valid_data) { "no" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step:, history: [previous_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("Do you need this information for an upcoming court case or hearing?")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { upcoming_court_case: invalid_data } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Choose if you need this information for an upcoming court date or hearing")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { upcoming_court_case: valid_data } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { upcoming_court_case: valid_data } }
          expect(request.session[:information_request][:upcoming_court_case]).to eq valid_data
        end
      end

      it_behaves_like "question with back link"

      context "when user has upcoming court case" do
        context "when submitting form with invalid data" do
          it "renders page with error message" do
            patch "/request", params: { request_form: { upcoming_court_case: "yes" } }
            expect(response).to render_template(:edit)
            expect(response.body).to include("There is a problem")
            expect(response.body).to include("Provide more details")
          end
        end
      end
    end
  end
end
