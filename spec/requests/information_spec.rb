require "rails_helper"

RSpec.describe "Information required", type: :request do
  describe "/prison-location" do
    let(:current_step) { "prison-location" }

    it_behaves_like "question that requires a session"

    context "when session in progress" do
      let(:information_request) { build(:information_request_for_prison_service) }
      let(:previous_step) { "/hmpps" }
      let(:next_step) { "/prison-number" }
      let(:valid_data) { "no" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step:, history: [previous_step])
        get "/#{current_step}"
      end

      it "renders the hmpps page" do
        expect(response).to render_template(:show)
        expect(response.body).to include("Are you currently in prison?")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { currently_in_prison: invalid_data } }
          expect(response).to render_template(:show)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Are you currently in prison")
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
    let(:current_step) { "prison-number" }

    it_behaves_like "question that requires a session"

    context "when session in progress" do
      let(:previous_step) { "/prison-number" }
      let(:next_step) { "/prison-data" }
      let(:valid_data) { "AA1234" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step:, history: [previous_step])
        get "/#{current_step}"
      end

      context "when requesting own data" do
        let(:information_request) { build(:information_request_for_prison_service) }

        it "renders the subject-name page" do
          expect(response).to render_template(:show)
          expect(response.body).to include("What is your prison number?")
        end

        context "when submitting form with invalid data" do
          it "renders page with error message" do
            patch "/request", params: { request_form: { prison_number: invalid_data } }
            expect(response).to render_template(:show)
            expect(response.body).to include("There is a problem")
            expect(response.body).to include("Enter your prison number")
          end
        end

        it_behaves_like "question that accepts valid data", :prison_number
        it_behaves_like "question with back link"
      end

      context "when requesting someone else's data" do
        let(:information_request) { build(:information_request_for_prison_service, subject: "other") }

        it "renders the subject-name page" do
          expect(response).to render_template(:show)
          expect(response.body).to include("What is their prison number?")
        end

        context "when submitting form with invalid data" do
          it "renders page with error message" do
            patch "/request", params: { request_form: { prison_number: invalid_data } }
            expect(response).to render_template(:show)
            expect(response.body).to include("There is a problem")
            expect(response.body).to include("Enter their prison number")
          end
        end
      end
    end
  end
end
