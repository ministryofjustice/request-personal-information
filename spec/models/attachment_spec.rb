require "rails_helper"

RSpec.describe Attachment, type: :model do
  subject(:attachment) { described_class.new(file: fixture_file_upload("file.jpg")) }

  describe "#to_s" do
    it "returns the file name and file size" do
      expect(attachment.to_s).to eq "file.jpg, 24 KB"
    end
  end

  describe "#filename" do
    it "returns the file name" do
      expect(attachment.filename).to eq "file.jpg"
    end
  end

  describe "#purge_file" do
    it "requests the file is purged" do
      expect(attachment.file).to receive(:purge_later)
      attachment.purge_file
    end

    it "requests the file is purged on destroy" do
      expect(attachment.file).to receive(:purge_later)
      attachment.destroy!
    end
  end

  describe "#payload" do
    let(:expected_url) { "https://www.example.com" }

    it "returns file details to send to API" do
      allow(attachment.file).to receive(:url).and_return(expected_url)

      expect(attachment.payload).to eq(
        {
          url: expected_url,
          filename: "file.jpg",
        },
      )
    end
  end
end
