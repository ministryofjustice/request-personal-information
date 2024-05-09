module RequestForm
  class LetterOfConsent < Base
    attribute :letter_of_consent
    attr_accessor :default

    validates :letter_of_consent, presence: true
    validate :check_file_size

    def required?
      !request.for_self?
    end

    def check_file_size
      return if letter_of_consent.nil?

      if File.size(letter_of_consent) > 7.megabytes
        errors.add(:letter_of_consent, "The selected file must be smaller than 7MB")
      end
    end
  end
end
