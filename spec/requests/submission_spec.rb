require "rails_helper"

RSpec.describe "form sent", type: :request do
  before do
    get "/form-sent"
  end

  it "renders the expected page" do
    expect(response).to render_template(:complete)
    expect(response.body).to include("Request sent")
  end
end
