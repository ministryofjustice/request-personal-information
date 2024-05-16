require "rails_helper"

RSpec.describe "Information required", type: :request do
  describe "/hmpps" do
    let(:current_step) { "hmpps" }

    context "when session not in progress" do
      it "redirects to the homepage" do
        get "/#{current_step}"
        expect(response).to redirect_to("/")
      end
    end

    context "when session in progress" do
      let(:information_request) { build(:information_request_for_self) }
      let(:previous_step) { "/subject-id-check" }
      let(:next_step) { "/" }
      let(:valid_data) { "no" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step:, history: [previous_step])
        get "/#{current_step}"
      end

      it "renders the hmpps page" do
        expect(response).to render_template(:show)
        expect(response.body).to include("Do you want personal information held by the Prison and Probation Service (HMPPS)?")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { hmpps_information: invalid_data } }
          expect(response).to render_template(:show)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Choose if you want information held by the Prison and Probation Service (HMPPS)")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { hmpps_information: valid_data } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { hmpps_information: valid_data } }
          expect(request.session[:information_request][:hmpps_information]).to eq valid_data
        end
      end

      context "when requesting hmpps information" do
        context "when submitting form with invalid data" do
          it "renders page with error message" do
            patch "/request", params: { request_form: { hmpps_information: "yes", hmpps: nil } }
            expect(response).to render_template(:show)
            expect(response.body).to include("There is a problem")
            expect(response.body).to include("Choose if you want information held by the Prison and Probation Service (HMPPS)")
          end
        end

        context "when submitting form with valid data" do
          it "goes to next step" do
            patch "/request", params: { request_form: { hmpps_information: "yes", prison_service: true } }
            expect(response).to redirect_to(next_step)
          end

          it "saves the value to the session" do
            patch "/request", params: { request_form: { hmpps_information: valid_data, prison_service: true } }
            expect(request.session[:information_request][:prison_service]).to eq true
          end
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
