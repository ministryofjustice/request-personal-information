module RequestForm
  class LetterOfConsentCheck < Base
    OPTIONS = {
      "yes": "Yes, add this upload",
      "no": "No, I want to choose a different upload",
    }.freeze

    attr_accessor :default, :letter_of_consent_check

    validates :check, presence: true

    def required?
      !request.for_self?
    end
  end
end
