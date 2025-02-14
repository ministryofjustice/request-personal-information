require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "#homepage" do
    it "shows the homepage" do
      get root_path
      expect(response).to be_successful
      expect(response.body).to include("Request personal information from the Ministry of Justice")
    end
  end

  describe "#accessibility" do
    it "shows the accessibility page" do
      get "/accessibility"
      expect(response).to be_successful
      expect(response.body).to include("Accessibility statement")
    end
  end

  describe "#privacy" do
    it "shows the privacy page" do
      get "/privacy"
      expect(response).to be_successful
      expect(response.body).to include("Privacy notice")
    end
  end
end
