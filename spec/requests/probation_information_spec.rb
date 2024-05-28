require "rails_helper"

RSpec.describe "Data required from probation service", type: :request do
  describe "/probation-location" do
    let(:information_request) { build(:information_request_for_probation_service) }
    let(:current_step) { "probation-location" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "moj" }
      let(:next_step) { "/probation-information" }
      let(:valid_data) { "probation office" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("Where is your probation office or approved premises?")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { probation_office: invalid_data } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Enter your probation office or approved premises")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { currently_in_probation: valid_data, probation_office: valid_data } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { currently_in_probation: valid_data, probation_office: valid_data } }
          expect(request.session[:information_request][:probation_office]).to eq valid_data
        end
      end

      it_behaves_like "question with back link"
    end
  end

  describe "/probation-information" do
    let(:information_request) { build(:information_request_for_probation_service) }
    let(:current_step) { "probation-information" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "probation-location" }
      let(:next_step) { "/probation-dates" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("What probation service information do you want?")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { default: 1 } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Enter an answer for")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { probation_ndelius: "true" } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { probation_ndelius: "true" } }
          expect(request.session[:information_request][:probation_ndelius]).to eq true
        end
      end

      it_behaves_like "question with back link"
    end
  end

  describe "/probation-dates" do
    let(:information_request) { build(:information_request_for_probation_service) }
    let(:current_step) { "probation-dates" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "probation-information" }
      let(:next_step) { "/contact-address" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("What dates do you want this information from? (optional)")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { "probation_date_from(3i)": "1", "probation_date_from(2i)": "1", "probation_date_from(1i)": "" } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Enter a valid date this information should start from")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { "probation_date_from(3i)": "1", "probation_date_from(2i)": "1", "probation_date_from(1i)": "2000" } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { "probation_date_from(3i)": "1", "probation_date_from(2i)": "1", "probation_date_from(1i)": "2000" } }
          expect(request.session[:information_request][:probation_date_from]).to eq Date.new(2000, 1, 1)
        end
      end

      it_behaves_like "question with back link"
    end
  end
end
