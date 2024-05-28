require "rails_helper"

RSpec.describe InformationRequestSummary, type: :model do
  subject(:summary) { described_class.new(information_request) }

  describe "#subject" do
    context "when for self" do
      let(:information_request) { build(:information_request_for_self) }

      it "returns details about the subject's full name" do
        expect(summary.subject[0]).to include({ key: { text: "Full name" } })
        expect(summary.subject[0]).to include({ value: { text: "Cristian Romero" } })
      end

      it "returns details about the subject's other names" do
        expect(summary.subject[1]).to include({ key: { text: "Any other names that your information may be stored under? (optional)" } })
        expect(summary.subject[1]).to include({ value: { text: "Cuti" } })
      end

      it "returns details about the subject's date of birth" do
        expect(summary.subject[2]).to include({ key: { text: "What is your date of birth?" } })
        expect(summary.subject[2]).to include({ value: { text: "1998-04-27" } })
      end
    end

    context "when for someone else" do
      let(:information_request) { build(:information_request_by_solicitor) }

      it "returns details about the subject's full name" do
        expect(summary.subject[0]).to include({ key: { text: "Full name" } })
        expect(summary.subject[0]).to include({ value: { text: "Cristian Romero" } })
      end

      it "returns details about the subject's other names" do
        expect(summary.subject[1]).to include({ key: { text: "Any other names that their information may be stored under? (optional)" } })
        expect(summary.subject[1]).to include({ value: { text: "Cuti" } })
      end

      it "returns details about the subject's date of birth" do
        expect(summary.subject[2]).to include({ key: { text: "What is their date of birth?" } })
        expect(summary.subject[2]).to include({ value: { text: "1998-04-27" } })
      end

      it "returns relationship of requester to the subject" do
        expect(summary.subject[3]).to include({ key: { text: "What is your relationship to them?" } })
        expect(summary.subject[3]).to include({ value: { text: "Legal representative" } })
      end
    end
  end

  describe "#requester" do
    context "when for self" do
      let(:information_request) { build(:information_request_for_self) }

      it "returns nil" do
        expect(summary.requester).to be_nil
      end
    end

    context "when requested by solicitor" do
      let(:information_request) { build(:information_request_by_solicitor) }

      it "returns details about the organisations name" do
        expect(summary.requester[0]).to include({ key: { text: "Name of your organisation" } })
        expect(summary.requester[0]).to include({ value: { text: "Van de Ven Solicitors" } })
      end

      it "returns details about the requester's name" do
        expect(summary.requester[1]).to include({ key: { text: "Your full name (optional)" } })
        expect(summary.requester[1]).to include({ value: { text: "Micky" } })
      end
    end

    context "when requested by friend or family" do
      let(:information_request) { build(:information_request_by_friend) }

      it "returns details about the requester's name" do
        expect(summary.requester[0]).to include({ key: { text: "Your full name" } })
        expect(summary.requester[0]).to include({ value: { text: "Radu" } })
      end
    end
  end

  describe "#requester_id" do
    context "when for self" do
      let(:information_request) { build(:information_request_for_self) }

      it "returns nil" do
        expect(summary.requester_id).to be_nil
      end
    end

    context "when requested by solicitor" do
      let(:information_request) { build(:information_request_by_solicitor) }

      it "returns letter of consent details" do
        expect(summary.requester_id[0]).to include({ key: { text: "Upload a letter of consent" } })
        expect(summary.requester_id[0]).to include({ value: { text: "file.jpg, 12.2 KB" } })
      end
    end

    context "when requested by friend or family" do
      let(:information_request) { build(:information_request_by_friend) }

      it "returns requester photo id details" do
        expect(summary.requester_id[0]).to include({ key: { text: "Photo ID" } })
        expect(summary.requester_id[0]).to include({ value: { text: "file.jpg, 12.2 KB" } })
      end

      it "returns requester proof of address details" do
        expect(summary.requester_id[1]).to include({ key: { text: "Proof of address" } })
        expect(summary.requester_id[1]).to include({ value: { text: "file.jpg, 12.2 KB" } })
      end

      it "returns letter of consent details" do
        expect(summary.requester_id[2]).to include({ key: { text: "Upload a letter of consent" } })
        expect(summary.requester_id[2]).to include({ value: { text: "file.jpg, 12.2 KB" } })
      end
    end
  end

  describe "#subject_id" do
    context "when for self" do
      let(:information_request) { build(:information_request_for_self) }

      it "returns subject photo id details" do
        expect(summary.subject_id[0]).to include({ key: { text: "Photo ID" } })
        expect(summary.subject_id[0]).to include({ value: { text: "file.jpg, 12.2 KB" } })
      end

      it "returns subject proof of address details" do
        expect(summary.subject_id[1]).to include({ key: { text: "Proof of address" } })
        expect(summary.subject_id[1]).to include({ value: { text: "file.jpg, 12.2 KB" } })
      end
    end

    context "when requested by solicitor" do
      let(:information_request) { build(:information_request_by_solicitor) }

      it "returns nil" do
        expect(summary.subject_id).to be_nil
      end
    end

    context "when requested by friend or family" do
      let(:information_request) { build(:information_request_by_friend) }

      it "returns subject photo id details" do
        expect(summary.subject_id[0]).to include({ key: { text: "Photo ID" } })
        expect(summary.subject_id[0]).to include({ value: { text: "file.jpg, 12.2 KB" } })
      end

      it "returns subject proof of address details" do
        expect(summary.subject_id[1]).to include({ key: { text: "Proof of address" } })
        expect(summary.subject_id[1]).to include({ value: { text: "file.jpg, 12.2 KB" } })
      end
    end
  end

  describe "#information" do
    let(:information_request) { build(:information_request_for_prison_service) }

    it "returns list of information required" do
      expect(summary.information[0]).to include({ key: { text: "Select all that apply" } })
      expect(summary.information[0]).to include({ value: { text: "Prison Service" } })
    end

    context "when requesting other information" do
      let(:information_request) { build(:information_request_for_moj_other) }

      it "returns list of information required" do
        expect(summary.information[0]).to include({ key: { text: "Select all that apply" } })
        expect(summary.information[0]).to include({ value: { text: "Somewhere else in the Ministry of Justice" } })
      end

      it "returns where other information is held" do
        expect(summary.information[1]).to include({ key: { text: "Where in the Ministry of Justice do you think this information is held?" } })
        expect(summary.information[1]).to include({ value: { text: "other location" } })
      end
    end
  end

  describe "#prison" do
    context "when requesting prison service information" do
      let(:information_request) { build(:information_request_for_prison_service) }

      it "returns if the subject is currently in prison" do
        expect(summary.prison[0]).to include({ key: { text: "Are you currently in prison?" } })
        expect(summary.prison[0]).to include({ value: { text: "Yes" } })
      end

      it "returns where the subject is in prison" do
        expect(summary.prison[1]).to include({ key: { text: "Which prison are you in?" } })
        expect(summary.prison[1]).to include({ value: { text: "HMP Fosse Way" } })
      end

      it "returns where the subject's prison number" do
        expect(summary.prison[2]).to include({ key: { text: "What is your prison number?" } })
        expect(summary.prison[2]).to include({ value: { text: "ABC123" } })
      end

      it "returns what information is required" do
        expect(summary.prison[3]).to include({ key: { text: "What prison service information do you want?" } })
        expect(summary.prison[3]).to include({ value: { text: "NOMIS Records" } })
      end

      it "returns dates information is required for" do
        expect(summary.prison[4]).to include({ key: { text: "Enter a date this information should start from (optional)" } })
        expect(summary.prison[4]).to include({ value: { text: "2010-03-10" } })
        expect(summary.prison[5]).to include({ key: { text: "Enter a date this information should go to (optional)" } })
        expect(summary.prison[5]).to include({ value: { text: "2012-05-20" } })
      end

      context "when not currently in prison" do
        it "returns which prison the subject was most recently in" do
          information_request.currently_in_prison = "no"
          information_request.recent_prison_name = "HMP Hollesley Bay"

          expect(summary.prison[1]).to include({ key: { text: "Which prison where you most recently in?" } })
          expect(summary.prison[1]).to include({ value: { text: "HMP Hollesley Bay" } })
        end
      end

      context "when requesting other prison data" do
        it "returns details of the other information required" do
          information_request.prison_other_data = true
          information_request.prison_other_data_text = "this is details of information required"

          expect(summary.prison[3]).to include({ value: { text: "NOMIS Records, Something else" } })
          expect(summary.prison[4]).to include({ key: { text: "Can you provide more detail?" } })
          expect(summary.prison[4]).to include({ value: { text: "this is details of information required" } })
        end
      end
    end

    context "when not requesting prison service information" do
      let(:information_request) { build(:information_request_for_probation_service) }

      it "returns nil" do
        expect(summary.prison).to be_nil
      end
    end
  end

  describe "#probation" do
    context "when requesting probation service information" do
      let(:information_request) { build(:information_request_for_probation_service) }

      it "returns the name of the probation location" do
        expect(summary.probation[0]).to include({ key: { text: "Where is your probation office or approved premises?" } })
        expect(summary.probation[0]).to include({ value: { text: "Leicester" } })
      end

      it "returns which probation information is required" do
        expect(summary.probation[1]).to include({ key: { text: "What probation service information do you want?" } })
        expect(summary.probation[1]).to include({ value: { text: "nDelius file" } })
      end

      it "returns dates information is required for" do
        expect(summary.probation[2]).to include({ key: { text: "Enter a date this information should start from (optional)" } })
        expect(summary.probation[2]).to include({ value: { text: "2014-01-12" } })
        expect(summary.probation[3]).to include({ key: { text: "Enter a date this information should go to (optional)" } })
        expect(summary.probation[3]).to include({ value: { text: "2020-11-02" } })
      end

      context "when requesting other prison data" do
        it "returns details of the other information required" do
          information_request.probation_other_data = true
          information_request.probation_other_data_text = "this is details of information required"

          expect(summary.probation[1]).to include({ value: { text: "nDelius file, Something else" } })
          expect(summary.probation[2]).to include({ key: { text: "Can you provide more detail?" } })
          expect(summary.probation[2]).to include({ value: { text: "this is details of information required" } })
        end
      end
    end

    context "when not requesting probation service information" do
      let(:information_request) { build(:information_request_for_prison_service) }

      it "returns nil" do
        expect(summary.probation).to be_nil
      end
    end
  end

  describe "#laa" do
    context "when requesting LAA information" do
      let(:information_request) { build(:information_request_for_laa) }

      it "returns which information is required" do
        expect(summary.laa[0]).to include({ key: { text: "What information do you want from the Legal Aid Agency (LAA)?" } })
        expect(summary.laa[0]).to include({ value: { text: "laa details" } })
      end

      it "returns dates information is required for" do
        expect(summary.laa[1]).to include({ key: { text: "Enter a date this information should start from (optional)" } })
        expect(summary.laa[1]).to include({ value: { text: "2015-01-20" } })
        expect(summary.laa[2]).to include({ key: { text: "Enter a date this information should go to (optional)" } })
        expect(summary.laa[2]).to include({ value: { text: "2016-03-01" } })
      end
    end

    context "when not requesting laa information" do
      let(:information_request) { build(:information_request_for_prison_service) }

      it "returns nil" do
        expect(summary.laa).to be_nil
      end
    end
  end

  describe "#opg" do
    context "when requesting OPG information" do
      let(:information_request) { build(:information_request_for_opg) }

      it "returns which information is required" do
        expect(summary.opg[0]).to include({ key: { text: "What information do you want from the Office of the Public Guardian (OPG)?" } })
        expect(summary.opg[0]).to include({ value: { text: "opg details" } })
      end

      it "returns dates information is required for" do
        expect(summary.opg[1]).to include({ key: { text: "Enter a date this information should start from (optional)" } })
        expect(summary.opg[1]).to include({ value: { text: "2017-07-19" } })
        expect(summary.opg[2]).to include({ key: { text: "Enter a date this information should go to (optional)" } })
        expect(summary.opg[2]).to include({ value: { text: "2019-03-02" } })
      end
    end

    context "when not requesting opg information" do
      let(:information_request) { build(:information_request_for_prison_service) }

      it "returns nil" do
        expect(summary.opg).to be_nil
      end
    end
  end

  describe "#moj_other" do
    context "when requesting other MOJ information" do
      let(:information_request) { build(:information_request_for_moj_other) }

      it "returns which information is required" do
        expect(summary.moj_other[0]).to include({ key: { text: "What information do you want from somewhere else in the Ministry of Justice?" } })
        expect(summary.moj_other[0]).to include({ value: { text: "other details" } })
      end

      it "returns dates information is required for" do
        expect(summary.moj_other[2]).to include({ key: { text: "Enter a date this information should go to (optional)" } })
        expect(summary.moj_other[2]).to include({ value: { text: "1990-12-31" } })
      end
    end

    context "when not requesting opg information" do
      let(:information_request) { build(:information_request_for_prison_service) }

      it "returns nil" do
        expect(summary.moj_other).to be_nil
      end
    end
  end

  describe "#contact" do
    let(:information_request) { build(:complete_request) }

    it "returns contact address" do
      expect(summary.contact[0]).to include({ key: { text: "Your address" } })
      expect(summary.contact[0]).to include({ value: { text: "1 High Street, Paignton, Devon" } })
    end

    it "returns email address" do
      expect(summary.contact[1]).to include({ key: { text: "Email address (optional)" } })
      expect(summary.contact[1]).to include({ value: { text: "my@email.com" } })
    end

    it "returns whether the subject has an upcoming court date or hearing" do
      expect(summary.contact[2]).to include({ key: { text: "Do you need this information for an upcoming court case or hearing?" } })
      expect(summary.contact[2]).to include({ value: { text: "No" } })
    end

    context "when subject has upcoming court date or hearing" do
      it "returns details of the upcoming court case or hearing" do
        information_request.upcoming_court_case = "yes"
        information_request.upcoming_court_case_text = "details of court case"

        expect(summary.contact[3]).to include({ key: { text: "Can you provide more details?" } })
        expect(summary.contact[3]).to include({ value: { text: "details of court case" } })
      end
    end
  end
end
