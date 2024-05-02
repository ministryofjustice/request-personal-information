require "rails_helper"

def set_session(vars = {})
  post test_session_path, params: { session_vars: vars }
end

RSpec.describe "Subject", type: :request do
  let(:information_request) { InformationRequest.new }

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
      before do
        set_session(information_request: information_request.to_hash, current_step: "subject", history: ["/"])
        get "/subject"
      end

      it "renders the subject page" do
        expect(response).to render_template(:show)
        expect(response.body).to include("Are you requesting your own information or on behalf of someone else?")
      end

      context "when submitting form without entry" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { subject: "" } }
          expect(response).to render_template(:show)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include(CGI.escapeHTML("Choose if you're requesting information for yourself or for someone else"))
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { subject: "self" } }
          expect(response).to redirect_to("/subject-name")
        end
      end

      context "when going back" do
        it "goes to previous step" do
          get("/request/back")
          expect(response).to redirect_to("/")
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
      context "when requesting own data" do
        let(:information_request) { InformationRequest.new(subject: "self") }

        before do
          set_session(information_request: information_request.to_hash, current_step: "subject-name", history: ["/", "/subject"])
          get "/subject-name"
        end

        it "renders the subject-name page" do
          expect(response).to render_template(:show)
          expect(response.body).to include("What is your name?")
        end

        context "when going back" do
          it "goes to previous step" do
            get("/request/back")
            expect(response).to redirect_to("/subject")
          end
        end

        context "when submitting form without entry" do
          it "renders page with error message" do
            patch "/request", params: { request_form: { full_name: "" } }
            expect(response).to render_template(:show)
            expect(response.body).to include("There is a problem")
            expect(response.body).to include("Enter your full name")
          end
        end

        context "when submitting form with valid data" do
          it "goes to next step" do
            patch "/request", params: { request_form: { full_name: "my name" } }
            expect(response).to redirect_to("/subject-date-of-birth")
          end
        end
      end

      context "when requesting someone else's data" do
        let(:information_request) { InformationRequest.new(subject: "other") }

        before do
          set_session(information_request: information_request.to_hash, current_step: "subject-name", history: [])
          get "/subject-name"
        end

        it "renders the subject-name page" do
          expect(response).to render_template(:show)
          expect(response.body).to include("What is their name?")
        end

        context "when submitting form without entry" do
          it "renders page with error message" do
            patch "/request", params: { request_form: { full_name: "" } }
            expect(response).to render_template(:show)
            expect(response.body).to include("There is a problem")
            expect(response.body).to include("Enter their full name")
          end
        end

        context "when submitting form with valid data" do
          it "goes to next step" do
            patch "/request", params: { request_form: { full_name: "their name" } }
            expect(response).to redirect_to("/subject-date-of-birth")
          end
        end
      end
    end
  end
end
