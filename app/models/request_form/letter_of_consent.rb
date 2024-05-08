module RequestForm
  class LetterOfConsent < Base
    attr_accessor :letter_of_consent, :default

    validates :letter_of_consent, presence: true

    def required?
      !request.for_self?
    end
  end
end
