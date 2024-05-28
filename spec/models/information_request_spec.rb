require "rails_helper"

RSpec.describe InformationRequest, type: :model do
  describe "#for_self?" do
    context "when request subject is the requester" do
      it "returns expected value" do
        request = described_class.new(subject: "self")
        expect(request).to be_for_self
      end
    end

    context "when request subject is someone else" do
      it "returns expected value" do
        request = described_class.new(subject: "other")
        expect(request).not_to be_for_self
      end
    end
  end

  describe "#by_solicitor?" do
    context "when request subject is the requester" do
      it "returns expected value" do
        request = described_class.new(subject: "self")
        expect(request).not_to be_by_solicitor
      end
    end

    context "when request subject is someone else" do
      context "when requester is a solicitor" do
        it "returns expected value" do
          request = described_class.new(subject: "other", relationship: "legal_representative")
          expect(request).to be_by_solicitor
        end
      end

      context "when request subject is someone else" do
        it "returns expected value" do
          request = described_class.new(subject: "other", relationship: "other")
          expect(request).not_to be_by_solicitor
        end
      end
    end
  end

  describe "#pronoun" do
    context "when request subject is the requester" do
      it "returns expected value" do
        request = described_class.new(subject: "self")
        expect(request.pronoun).to eq "you"
      end
    end

    context "when request subject is someone else" do
      it "returns expected value" do
        request = described_class.new(subject: "other")
        expect(request.pronoun).to eq "they"
      end
    end
  end

  describe "#possessive_pronoun" do
    context "when request subject is the requester" do
      it "returns expected value" do
        request = described_class.new(subject: "self")
        expect(request.possessive_pronoun).to eq "your"
      end
    end

    context "when request subject is someone else" do
      it "returns expected value" do
        request = described_class.new(subject: "other")
        expect(request.possessive_pronoun).to eq "their"
      end
    end
  end

  describe "#letter_of_consent=" do
    it "creates an attachment object" do
      request = described_class.new
      request.letter_of_consent = fixture_file_upload("file.jpg")
      expect(request.letter_of_consent_id).not_to be_nil
      expect(Attachment.all.size).to eq 1
    end
  end

  describe "#requester_photo=" do
    it "creates an attachment object" do
      request = described_class.new
      request.requester_photo = fixture_file_upload("file.jpg")
      expect(request.requester_photo_id).not_to be_nil
      expect(Attachment.all.size).to eq 1
    end
  end

  describe "#requester_proof_of_address=" do
    it "creates an attachment object" do
      request = described_class.new
      request.requester_proof_of_address = fixture_file_upload("file.jpg")
      expect(request.requester_proof_of_address_id).not_to be_nil
      expect(Attachment.all.size).to eq 1
    end
  end

  describe "#subject_photo=" do
    it "creates an attachment object" do
      request = described_class.new
      request.subject_photo = fixture_file_upload("file.jpg")
      expect(request.subject_photo_id).not_to be_nil
      expect(Attachment.all.size).to eq 1
    end
  end

  describe "#subject_proof_of_address=" do
    it "creates an attachment object" do
      request = described_class.new
      request.subject_proof_of_address = fixture_file_upload("file.jpg")
      expect(request.subject_proof_of_address_id).not_to be_nil
      expect(Attachment.all.size).to eq 1
    end
  end

  describe "#to_hash" do
    it "contains all the attributes" do
      request = described_class.new(subject: "other", full_name: "full name", other_names: "other names", date_of_birth: Date.new(2000, 1, 1))
      expect(request.to_hash).to include({ "subject": "other" })
      expect(request.to_hash).to include({ "full_name": "full name" })
      expect(request.to_hash).to include({ "other_names": "other names" })
      expect(request.to_hash).to include({ "date_of_birth": Date.new(2000, 1, 1) })
    end
  end
end
