require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "#homepage" do
    it "shows the homepage" do
      get root_path
      expect(response).to be_successful
      expect(response.body).to include("Request personal information from the Ministry of Justice")
    end
  end
end
