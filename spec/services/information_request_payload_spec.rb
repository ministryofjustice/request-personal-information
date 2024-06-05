require "rails_helper"

RSpec.describe InformationRequestPayload, type: :service do
  let(:information_request) { create(:complete_request) }

  describe "#call" do
    subject(:payload) { described_class.new(information_request).call }

    it "returns a hash including the submission id" do
      expect(payload[:submission_id]).to eq information_request.submission_id
    end

    it "returns a hash including the answers" do
      expect(payload[:answers]).to eq (
        {
          full_name: "Cristian Romero",
          other_names: "Cuti",
          date_of_birth: Date.new(1998, 4, 27),
          organisation_name: nil,
          requester_name: nil,
          hmpps_information: nil,
          current_prison_name: nil,
          recent_prison_name: "HMP Fosse Way",
          prison_number: "ABC123",
          prison_other_data_text: nil,
          prison_date_from: Date.new(2010, 3, 10),
          prison_date_to: Date.new(2012, 5, 20),
          probation_office: nil,
          probation_other_data_text: nil,
          probation_date_from: nil,
          probation_date_to: nil,
          moj_other_where: nil,
          laa_text: nil,
          laa_date_from: nil,
          laa_date_to: nil,
          opg_text: nil,
          opg_date_from: nil,
          opg_date_to: nil,
          moj_other_text: nil,
          moj_other_date_from: nil,
          moj_other_date_to: nil,
          contact_address: "1 High Street, Paignton, Devon",
          contact_email: "my@email.com",
          upcoming_court_case_text: nil,
          subject: "Your own",
          relationship: "",
          currently_in_prison: "No",
          upcoming_court_case: "No",
          prison_information: "NOMIS Records",
          probation_information: "",
          letter_of_consent_file_name: nil,
          requester_photo_file_name: nil,
          requester_proof_of_address_file_name: nil,
          subject_photo_file_name: "file.jpg",
          subject_proof_of_address_file_name: "file.jpg",
          prison_service: "Yes",
          probation_service: "No",
          laa: "No",
          opg: "No",
          moj_other: "No",
        }
      )
    end

    it "returns a hash including the attachments" do
      expect(payload[:attachments][0][:filename]).to eq(information_request.subject_photo.payload[:filename])
      expect(payload[:attachments][1][:filename]).to eq(information_request.subject_proof_of_address.payload[:filename])
    end
  end
end
