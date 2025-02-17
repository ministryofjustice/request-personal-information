RSpec.shared_examples("question that requires a session") do
  context "when session not in progress" do
    it "redirects to the homepage" do
      get "/#{current_step}"
      expect(response).to redirect_to("/")
    end
  end
end

RSpec.shared_examples("question that must be accessed in order") do
  context "when accessed directly without a previous visit" do
    it "redirects to the previous closest step" do
      set_session(information_request: information_request.to_hash, current_step: "example", history: [])
      get "/#{current_step}"
      expect(response).to redirect_to("/example")
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
      expect(response).to redirect_to("/#{previous_step}")
    end
  end

  context "when return path is specified" do
    it "goes to specified step" do
      history = session[:history] << "subject"
      set_session(history:)

      get("/request/back?return_to=subject")
      expect(response).to redirect_to("/subject")
    end
  end
end

RSpec.shared_examples("question with a title") do |title|
  it "renders the expected title" do
    expect(response.body).to have_selector("h1", text: title)
    expect(response.body).to have_title("#{title} - Request personal information")
  end
end
