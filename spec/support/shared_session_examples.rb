RSpec.shared_examples("question that requires a session") do
  context "when session not in progress" do
    it "redirects to the homepage" do
      get "/#{current_step}"
      expect(response).to redirect_to("/")
    end
  end
end

RSpec.shared_examples("question that accepts valid data") do |attribute|
  context "when submitting form with valid data" do
    it "goes to next step" do
      patch "/request", params: { request_form: { attribute => valid_data } }
      expect(response).to redirect_to(next_step)
    end

    it "saves the value to the session" do
      patch "/request", params: { request_form: { attribute => valid_data } }
      expect(request.session[:information_request][attribute]).to eq valid_data
    end
  end
end

RSpec.shared_examples("question with back link") do
  context "when going back" do
    it "goes to previous step" do
      get("/request/back")
      expect(response).to redirect_to(previous_step)
    end
  end
end
