require "rails_helper"

RSpec.describe AnalyticsHelper, type: :helper do
  describe "#analytics_consent_cookie" do
    it "retrieves the analytics consent cookie" do
      expect(controller.cookies).to receive(:[]).with("rpi_cookies_consent")
      helper.analytics_consent_cookie
    end
  end

  describe "#analytics_allowed?" do
    before do
      allow(controller.cookies).to receive(:[]).with("rpi_cookies_consent").and_return(value)
    end

    context "when cookies has been accepted" do
      let(:value) { ConsentCookie::ACCEPT }

      it { expect(helper.analytics_allowed?).to be true }
    end

    context "when cookies has been rejected" do
      let(:value) { ConsentCookie::REJECT }

      it { expect(helper.analytics_allowed?).to be false }
    end
  end
end
