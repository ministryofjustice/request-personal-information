require "rails_helper"

RSpec.describe "contact information", type: :request do
  describe "/contact-address" do
    let(:information_request) { build(:information_request_for_laa) }
    let(:current_step) { "contact-address" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "laa-dates" }
      let(:next_step) { "/contact-email" }
      let(:valid_data) { "address details" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
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

      it_behaves_like "question that accepts valid data", :contact_address
      it_behaves_like "question with back link"
    end
  end

  describe "/contact-email" do
    let(:information_request) { build(:information_request_for_laa) }
    let(:current_step) { "contact-email" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "contact-address" }
      let(:next_step) { "/upcoming" }
      let(:valid_data) { "email@domain.com" }
      let(:invalid_data) { "invalid" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
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
          expect(response.body).to include("Enter an email address in the correct format, like name@example.com")
        end
      end

      it_behaves_like "question that accepts valid data", :contact_email
      it_behaves_like "question with back link"
    end
  end

  describe "/upcoming" do
    let(:information_request) { build(:information_request_for_laa) }
    let(:current_step) { "upcoming" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "contact-email" }
      let(:next_step) { "/check-answers" }
      let(:valid_data) { "no" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
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
          expect(response.body).to include("Select if you need this information for an upcoming court case or hearing")
        end
      end

      it_behaves_like "question that accepts valid data", :upcoming_court_case
      it_behaves_like "question with back link"

      context "when user has upcoming court case" do
        context "when submitting form with invalid data" do
          it "renders page with error message" do
            patch "/request", params: { request_form: { upcoming_court_case: "yes" } }
            expect(response).to render_template(:edit)
            expect(response.body).to include("There is a problem")
            expect(response.body).to include(CGI.escapeHTML("Provide more details of the court case or hearing, such as when it's happening"))
          end
        end
      end
    end
  end
end
