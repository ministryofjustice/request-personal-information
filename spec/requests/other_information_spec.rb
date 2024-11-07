require "rails_helper"

RSpec.describe "Which data is required", type: :request do
  describe "/moj" do
    let(:information_request) { build(:information_request_for_self) }
    let(:current_step) { "moj" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "subject-id-check" }
      let(:next_step) { "/laa" }
      let(:valid_data) { "no" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("Where do you want information from?")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { moj: [] } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Select where you want information from")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { laa: "true" } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { laa: "true" } }
          expect(request.session[:information_request][:laa]).to be true
        end
      end

      it_behaves_like "question with back link"
    end
  end

  describe "/laa" do
    let(:information_request) { build(:information_request_for_laa) }
    let(:current_step) { "laa" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "moj" }
      let(:next_step) { "/laa-dates" }
      let(:valid_data) { "information required" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("What information do you want from the Legal Aid Agency (LAA)?")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { laa_text: invalid_data } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Describe the information you want from the Legal Aid Agency")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { laa_text: valid_data } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { laa_text: valid_data } }
          expect(request.session[:information_request][:laa_text]).to eq valid_data
        end
      end

      it_behaves_like "question with back link"
    end
  end

  describe "/laa-dates" do
    let(:information_request) { build(:information_request_for_laa) }
    let(:current_step) { "laa-dates" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "laa" }
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
          patch "/request", params: { request_form: { "form_laa_date_from(3i)": "123", "form_laa_date_from(2i)": "1", "form_laa_date_from(1i)": "2000" } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Enter a valid date this information should start from")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { "form_laa_date_from(3i)": "1", "form_laa_date_from(2i)": "1", "form_laa_date_from(1i)": "2000" } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { "form_laa_date_from(3i)": "1", "form_laa_date_from(2i)": "1", "form_laa_date_from(1i)": "2000" } }
          expect(request.session[:information_request][:laa_date_from]).to eq Date.new(2000, 1, 1)
        end
      end

      it_behaves_like "question with back link"
    end
  end

  describe "/opg" do
    let(:information_request) { build(:information_request_for_opg) }
    let(:current_step) { "opg" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "moj" }
      let(:next_step) { "/opg-dates" }
      let(:valid_data) { "information required" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("What information do you want from the Office of the Public Guardian (OPG)?")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { opg_text: invalid_data } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Describe the information you want from the Office of the Public Guardian")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { opg_text: valid_data } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { opg_text: valid_data } }
          expect(request.session[:information_request][:opg_text]).to eq valid_data
        end
      end

      it_behaves_like "question with back link"
    end
  end

  describe "/opg-dates" do
    let(:information_request) { build(:information_request_for_opg) }
    let(:current_step) { "opg-dates" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "opg" }
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
          patch "/request", params: { request_form: { "form_opg_date_from(3i)": "1", "form_opg_date_from(2i)": "1", "form_opg_date_from(1i)": "" } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Enter a valid date this information should start from")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { "form_opg_date_from(3i)": "1", "form_opg_date_from(2i)": "1", "form_opg_date_from(1i)": "2000" } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { "form_opg_date_from(3i)": "1", "form_opg_date_from(2i)": "1", "form_opg_date_from(1i)": "2000" } }
          expect(request.session[:information_request][:opg_date_from]).to eq Date.new(2000, 1, 1)
        end
      end

      it_behaves_like "question with back link"
    end
  end

  describe "/other-where" do
    let(:information_request) { build(:information_request_for_moj_other) }
    let(:current_step) { "other-where" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "moj" }
      let(:next_step) { "/other" }
      let(:valid_data) { "information required" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("Where in the Ministry of Justice do you think this information is held?")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { moj_other_where: invalid_data } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Enter where in the Ministry of Justice you think this information is held")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { moj_other_where: valid_data } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { moj_other_where: valid_data } }
          expect(request.session[:information_request][:moj_other_where]).to eq valid_data
        end
      end

      it_behaves_like "question with back link"
    end
  end

  describe "/other" do
    let(:information_request) { build(:information_request_for_moj_other) }
    let(:current_step) { "other" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "other-where" }
      let(:next_step) { "/other-dates" }
      let(:valid_data) { "information required" }
      let(:invalid_data) { "" }

      before do
        set_session(information_request: information_request.to_hash, current_step: previous_step, history: [previous_step, current_step])
        get "/#{current_step}"
      end

      it "renders the expected page" do
        expect(response).to render_template(:edit)
        expect(response.body).to include("What information do you want from somewhere else in the Ministry of Justice?")
      end

      context "when submitting form with invalid data" do
        it "renders page with error message" do
          patch "/request", params: { request_form: { moj_other_text: invalid_data } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Describe the information you want from somewhere else in the Ministry of Justice")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { moj_other_text: valid_data } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { moj_other_text: valid_data } }
          expect(request.session[:information_request][:moj_other_text]).to eq valid_data
        end
      end

      it_behaves_like "question with back link"
    end
  end

  describe "/other-dates" do
    let(:information_request) { build(:information_request_for_moj_other) }
    let(:current_step) { "other-dates" }

    it_behaves_like "question that requires a session"
    it_behaves_like "question that must be accessed in order"

    context "when session in progress" do
      let(:previous_step) { "other" }
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
          patch "/request", params: { request_form: { "form_moj_other_date_from(3i)": "1", "form_moj_other_date_from(2i)": "1", "form_moj_other_date_from(1i)": "" } }
          expect(response).to render_template(:edit)
          expect(response.body).to include("There is a problem")
          expect(response.body).to include("Enter a valid date this information should start from")
        end
      end

      context "when submitting form with valid data" do
        it "goes to next step" do
          patch "/request", params: { request_form: { "form_moj_other_date_from(3i)": "1", "form_moj_other_date_from(2i)": "1", "form_moj_other_date_from(1i)": "2000" } }
          expect(response).to redirect_to(next_step)
        end

        it "saves the value to the session" do
          patch "/request", params: { request_form: { "form_moj_other_date_from(3i)": "1", "form_moj_other_date_from(2i)": "1", "form_moj_other_date_from(1i)": "2000" } }
          expect(request.session[:information_request][:moj_other_date_from]).to eq Date.new(2000, 1, 1)
        end
      end

      it_behaves_like "question with back link"
    end
  end
end
