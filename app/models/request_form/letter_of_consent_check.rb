module RequestForm
  class LetterOfConsentCheck < Base
    OPTIONS = {
      "yes": "Yes, add this upload",
      "no": "No, I want to choose a different upload",
    }.freeze

    attr_accessor :default, :letter_of_consent_check

    validates :letter_of_consent_check, presence: true
    validate :check_value

    def required?
      !request.for_self?
    end

  private

    def check_value
      if letter_of_consent_check == "no"
        attachment = Attachment.find(request.letter_of_consent_id)
        attachment.destroy!
        request.letter_of_consent_id = nil
        self.back = true
      end
    end
  end
end
