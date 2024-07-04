require "rails_helper"

RSpec.describe "Data required from prison service", type: :request do
  describe "/prison-location" do
    let(:information_request) { build(:information_request_for_prison_service, subject: "other") }
    let(:current_step) { "prison-location" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "moj" }
      let(:next_step) { "/prison-number" }
      let(:valid_data) { "no" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      context "when request for yourself" do
        let(:information_request) { build(:information_request_for_prison_service) }

        it "renders the expected page" do
          expect(response).to render_template(:edit)
          expect(response.body).to include("Which prison were you most recently in?")
        end

        context "when submitting form with invalid data" do
          it "renders page with error message" do
            patch "/request", params: { request_form: { recent_prison_name: invalid_data } }
            expect(response).to render_template(:edit)
            expect(response.body).to include("There is a problem")
            expect(response.body).to include("Enter which prison you were most recently in")
          end
        end
      end

      context "when request for someone else" do
        it "renders the expected page" do
          expect(response).to render_template(:edit)
          expect(response.body).to include("Are they currently in prison?")
        end

        context "when submitting form with invalid data" do
          it "renders page with error message" do
            patch "/request", params: { request_form: { currently_in_prison: invalid_data } }
            expect(response).to render_template(:edit)
            expect(response.body).to include("There is a problem")
            expect(response.body).to include("Are they currently in prison")
          end
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { currently_in_prison: valid_data, recent_prison_name: "prison name" } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { currently_in_prison: valid_data, recent_prison_name: "prison name" } }
          expect(request.session[:information_request][:recent_prison_name]).to eq "prison name"
        end
      end

      it_behaves_like "question with back link"
    end
  end

  describe "/prison-number" do
    let(:information_request) { build(:information_request_for_prison_service) }
    let(:current_step) { "prison-number" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "prison-number" }
      let(:next_step) { "/prison-information" }
      let(:valid_data) { "AA1234" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      context "when requesting own data" do
        let(:information_request) { build(:information_request_for_prison_service) }

        it "renders the expected page" do
          expect(response).to render_template(:edit)
          expect(response.body).to include("What was your prison number? (optional)")
        end

        it_behaves_like "question that accepts valid data", :prison_number
        it_behaves_like "question with back link"
      end

      context "when requesting someone else's data" do
        let(:information_request) { build(:information_request_for_prison_service, subject: "other") }

        it "renders the expected page" do
          expect(response).to render_template(:edit)
          expect(response.body).to include("What is their prison number?")
        end

        context "when submitting form with invalid data" do
          it "renders page with error message" do
            patch "/request", params: { request_form: { prison_number: invalid_data } }
            expect(response).to render_template(:edit)
            expect(response.body).to include("There is a problem")
            expect(response.body).to include("Enter their prison number")
          end
        end
      end
    end
  end

  describe "/prison-information" do
    let(:information_request) { build(:information_request_for_prison_service) }
    let(:current_step) { "prison-information" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "prison-number" }
      let(:next_step) { "/prison-dates" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("What prison service information do you want?")
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
          patch "/request", params: { request_form: { prison_nomis_records: "true" } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { prison_nomis_records: "true" } }
          expect(request.session[:information_request][:prison_nomis_records]).to be true
        end
      end

      it_behaves_like "question with back link"
    end
  end

  describe "/prison-dates" do
    let(:information_request) { build(:information_request_for_prison_service) }
    let(:current_step) { "prison-dates" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "prison-information" }
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
          patch "/request", params: { request_form: { "form_prison_date_from(3i)": "1", "form_prison_date_from(2i)": "1", "form_prison_date_from(1i)": "" } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Enter a valid date this information should start from")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { "form_prison_date_from(3i)": "1", "form_prison_date_from(2i)": "1", "form_prison_date_from(1i)": "2000" } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { "form_prison_date_from(3i)": "1", "form_prison_date_from(2i)": "1", "form_prison_date_from(1i)": "2000" } }
          expect(request.session[:information_request][:prison_date_from]).to eq Date.new(2000, 1, 1)
        end
      end

      it_behaves_like "question with back link"
    end
  end
end
