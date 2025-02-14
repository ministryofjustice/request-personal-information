require "rails_helper"

RSpec.describe "consent cookie", type: :request do
  describe "cookies/accept" do
    it "sets cookie to accept" do
      get "/cookies/accept"
      expect(cookies["rpi_cookies_consent"]).to eq "accept"
    end

    it "redirects" do
      get "/cookies/accept"
      expect(request).to redirect_to root_path
    end

    it "sets the flash" do
      get "/cookies/accept"
      expect(flash[:cookies_consent_updated]).to eq "accept"
    end
  end

  describe "cookies/reject" do
    it "sets cookie to reject" do
      get "/cookies/reject"
      expect(cookies["rpi_cookies_consent"]).to eq "reject"
    end

    it "redirects" do
      get "/cookies/reject"
      expect(request).to redirect_to root_path
    end

    it "sets the flash" do
      get "/cookies/reject"
      expect(flash[:cookies_consent_updated]).to eq "reject"
    end
  end

  describe "cookies/invalid" do
    it "does not set cookie" do
      get "/cookies/invalid"
      expect(cookies["rpi_cookies_consent"]).to be_nil
    end

    it "returns 404" do
      get "/cookies/invalid"
      expect(response).to be_not_found
    end
  end
end
