require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "#homepage" do
    it "shows the homepage" do
      get root_path
      expect(response).to be_successful
      expect(response.body).to include("Request personal information from the Ministry of Justice")
    end
  end

  describe "#other-where" do
    it "shows the other-where page" do
      get other_where_path
      expect(response).to be_successful
      expect(response.body).to include("Where in the Ministry of Justice do you think this information is held")
    end
  end
end
