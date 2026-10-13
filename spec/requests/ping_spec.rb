require "rails_helper"

RSpec.describe "Ping", type: :request do
  describe "GET /ping" do
    it "returns a minimal JSON status with no build or infrastructure detail" do
      get "/ping"

      expect(JSON.parse(response.body)).to eq("status" => "ok")
    end
  end

  describe "GET /deploy_info" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("DEPLOY_DASHBOARD_SHARED_SECRET", nil).and_return("test-secret")
    end

    context "with a valid shared secret" do
      it "renders deployment information as JSON" do
        allow(Deployment).to receive(:info).and_return(foo: "bar")

        get "/deploy_info", headers: { "X-Deploy-Dashboard-Secret" => "test-secret" }

        expect(JSON.parse(response.body)).to eq("foo" => "bar")
      end
    end

    context "with an invalid shared secret" do
      it "returns unauthorized" do
        get "/deploy_info", headers: { "X-Deploy-Dashboard-Secret" => "wrong-secret" }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "without a shared secret header" do
      it "returns unauthorized" do
        get "/deploy_info"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
