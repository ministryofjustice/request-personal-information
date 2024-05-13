module RequestForm
  class LetterOfConsent < Base
    attribute :letter_of_consent
    attr_accessor :default

    validates :letter_of_consent, presence: true, file_size: { max: 7.megabytes }

    def required?
      !request.for_self?
    end
  end
end
