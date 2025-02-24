require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#title" do
    let(:title) { helper.content_for(:page_title) }

    before do
      helper.title(value)
    end

    context "with a blank value" do
      let(:value) { "" }

      it { expect(title).to eq("Request personal information") }
    end

    context "with a provided value" do
      let(:value) { "Test page" }

      it { expect(title).to eq("Test page - Request personal information") }
    end

    context "with a provided value with whitespace" do
      let(:value) { "Test page \n" }

      it { expect(title).to eq("Test page - Request personal information") }
    end
  end
end
