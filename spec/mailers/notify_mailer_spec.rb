require "rails_helper"

RSpec.describe NotifyMailer, type: :mailer do
  describe "new_request" do
    let(:mail) { described_class.new_request(request) }
    let(:request) { create(:complete_request) }

    it "renders the headers" do
      expect(mail.subject).to eq("Request Personal Information")
      expect(mail.to).to eq([request.contact_email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("The information you provided is shown below.")
      expect(mail.body.encoded).to match("## Your details")
    end

    it "renders personal information" do
      expect(mail.body.encoded).to match(/Full name:\s+Cristian Romero/)
      expect(mail.body.encoded).to match(/What is your date of birth\?:\s+27 April 1998/)
    end

    it "renders upload information" do
      expect(mail.body.encoded).to match("## Upload your ID")
      expect(mail.body.encoded).to match(/Proof of ID:\s+file.jpg, 12.2 KB/)
    end

    it "renders where information is required from" do
      expect(mail.body.encoded).to match("## Where do you want information from?")
      expect(mail.body.encoded).to match(/Select all that apply:\s+Prison service\s+Probation service\s/)
    end

    it "renders details of information required" do
      expect(mail.body.encoded).to match("## HM Prison Service")
      expect(mail.body.encoded).to match(/Which prison were you most recently in\?:\s+HMP Fosse Way/)
      expect(mail.body.encoded).to match(/What was your prison number\? \(optional\):\s+ABC123/)
      expect(mail.body.encoded).to match(/What prison service information do you want\?:\s+NOMIS Records/)
      expect(mail.body.encoded).to match(/Enter a date this information should start from:\s+10 March 2010/)
      expect(mail.body.encoded).to match(/Enter a date this information should go to:\s+20 May 2012/)
    end

    it "renders contact details" do
      expect(mail.body.encoded).to match("## Where we&#39;ll send the information")
      expect(mail.body.encoded).to match(/Your address:\s+1 High Street, Paignton, Devon/)
      expect(mail.body.encoded).to match(/Email address \(optional\):\s+my@email.com/)
      expect(mail.body.encoded).to match(/Do you need this information for an upcoming court case or hearing\?:\s+No/)
    end
  end

  describe "new_request_with_prison_number_blank" do
    let(:mail) { described_class.new_request(request) }
    let(:request) { create(:complete_request, prison_number: nil) }

    it "renders details of information required from HM Prison Service when prison number blank" do
      expect(mail.body.encoded).to match(/What was your prison number\? \(optional\):\s*\r?\n\r\n/)
    end
  end
end
