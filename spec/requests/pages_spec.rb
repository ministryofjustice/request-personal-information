require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "#homepage" do
    it "shows the homepage" do
      get root_path
      expect(response).to be_successful
      expect(response.body).to include("Request personal information from the Ministry of Justice")
    end
  end
  describe "#feedbackpage" do
    it "shows the feedback page" do
      get feedback_path
      expect(response).to be_successful
      expect(response.body).to include("Give feedback on this service")
      expect(response.body).to include("Overall, how did you feel about the service you received today?")
      expect(response.body).to include("How could we improve this service?")
    end
  end
end
