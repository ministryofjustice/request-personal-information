module RequestForm
  class LetterOfConsent < Base
    attribute :letter_of_consent
    attribute :letter_of_consent_id
    attr_accessor :default

    validates :letter_of_consent,
              presence: true,
              file_size: { max: 7.megabytes },
              unless: -> { Attachment.exists?(letter_of_consent_id) }

    def required?
      !request.for_self?
    end

    def saveable_attributes
      attrs = attributes.except("letter_of_consent_id")
      if letter_of_consent.nil?
        attrs.delete("letter_of_consent")
      end

      attrs
    end
  end
end
