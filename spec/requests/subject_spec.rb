require "rails_helper"

def set_session(vars = {})
  post test_session_path, params: { session_vars: vars }
end

RSpec.describe "Subject", type: :request do
  describe "#new" do
    it "redirects to the subject form" do
      get new_request_path
      expect(response).to redirect_to("/subject")
    end
  end

  describe "/subject" do
    context "when session not in progress" do
      it "redirects to the homepage" do
        get "/subject"

        expect(response).to redirect_to("/")
      end
    end

    context "when session in progress" do
      let(:information_request) { InformationRequest.new }
      let(:current_step) { "subject" }
      let(:previous_step) { "/" }
      let(:next_step) { "/subject-name" }
      let(:valid_data) { "self" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step:, history: [previous_step])
        get "/#{current_step}"
      end

      it "renders the subject page" do
        expect(response).to render_template(:show)
        expect(response.body).to include("Are you requesting your own information or on behalf of someone else?")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { subject: invalid_data } }
          expect(response).to render_template(:show)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include(CGI.escapeHTML("Choose if you're requesting information for yourself or for someone else"))
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { subject: valid_data } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { subject: valid_data } }
          expect(request.session[:information_request][:subject]).to eq valid_data
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

  describe "/subject-name" do
    context "when session not in progress" do
      it "redirects to the homepage" do
        get "/subject-name"

        expect(response).to redirect_to("/")
      end
    end

    context "when session in progress" do
      let(:information_request) { InformationRequest.new(subject:) }
      let(:current_step) { "subject-name" }
      let(:previous_step) { "/subject" }
      let(:next_step) { "/subject-date-of-birth" }
      let(:valid_data) { "subject name" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step:, history: [previous_step])
        get "/#{current_step}"
      end

      context "when requesting own data" do
        let(:subject) { "self" }

        it "renders the subject-name page" do
          expect(response).to render_template(:show)
          expect(response.body).to include("What is your name?")
        end

        context "when going back" do
          it "goes to previous step" do
            get("/request/back")
            expect(response).to redirect_to(previous_step)
          end
        end

        context "when submitting form with invalid data" do
          it "renders page with error message" do
            patch "/request", params: { request_form: { full_name: invalid_data } }
            expect(response).to render_template(:show)
            expect(response.body).to include("There is a problem")
            expect(response.body).to include("Enter your full name")
          end
        end

        context "when submitting form with valid data" do
          it "goes to next step" do
            patch "/request", params: { request_form: { full_name: valid_data } }
            expect(response).to redirect_to(next_step)
          end

          it "saves the value to the session" do
            patch "/request", params: { request_form: { full_name: valid_data } }
            expect(request.session[:information_request][:full_name]).to eq valid_data
          end
        end
      end

      context "when requesting someone else's data" do
        let(:subject) { "other" }

        it "renders the subject-name page" do
          expect(response).to render_template(:show)
          expect(response.body).to include("What is their name?")
        end

        context "when submitting form with invalid data" do
          it "renders page with error message" do
            patch "/request", params: { request_form: { full_name: invalid_data } }
            expect(response).to render_template(:show)
            expect(response.body).to include("There is a problem")
            expect(response.body).to include("Enter their full name")
          end
        end
      end
    end
  end

  describe "/subject-date-of-birth" do
    context "when session not in progress" do
      it "redirects to the homepage" do
        get "/subject-name"

        expect(response).to redirect_to("/")
      end
    end

    context "when session in progress" do
      let(:information_request) { InformationRequest.new(subject:) }
      let(:current_step) { "subject-date-of-birth" }
      let(:previous_step) { "/subject-name" }
      let(:next_step) { "/" }
      let(:valid_data) { Date.new(2000, 1, 1) }
      let(:invalid_data) { nil }

      before do
        set_session(information_request: information_request.to_hash, current_step:, history: [previous_step])
        get "/#{current_step}"
      end

      context "when requesting own data" do
        let(:subject) { "self" }

        it "renders the subject-name page" do
          expect(response).to render_template(:show)
          expect(response.body).to include("What is your date of birth?")
        end

        context "when going back" do
          it "goes to previous step" do
            get("/request/back")
            expect(response).to redirect_to(previous_step)
          end
        end

        context "when submitting form with invalid data" do
          it "renders page with error message" do
            patch "/request", params: { request_form: { date_of_birth: invalid_data } }
            expect(response).to render_template(:show)
            expect(response.body).to include("There is a problem")
            expect(response.body).to include("Enter your date of birth")
          end
        end

        context "when submitting form with valid data" do
          it "goes to next step" do
            patch "/request", params: { request_form: { date_of_birth: valid_data } }
            expect(response).to redirect_to(next_step)
          end

          it "saves the value to the session" do
            patch "/request", params: { request_form: { date_of_birth: valid_data } }
            expect(request.session[:information_request][:date_of_birth]).to eq valid_data.to_s
          end
        end
      end

      context "when requesting someone else's data" do
        let(:subject) { "other" }

        it "renders the subject-name page" do
          expect(response).to render_template(:show)
          expect(response.body).to include("What is their date of birth?")
        end

        context "when submitting form without entry" do
          it "renders page with error message" do
            patch "/request", params: { request_form: { date_of_birth: invalid_data } }
            expect(response).to render_template(:show)
            expect(response.body).to include("There is a problem")
            expect(response.body).to include("Enter their date of birth")
          end
        end
      end
    end
  end
end
