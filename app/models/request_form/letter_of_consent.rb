module RequestForm
  class LetterOfConsent < Base
    attribute :letter_of_consent
    attribute :letter_of_consent_id
    attr_accessor :default

    validates :letter_of_consent, presence: true, unless: -> { Attachment.exists?(letter_of_consent_id) }
    validates :letter_of_consent, file_size: { max: 7.megabytes }, file_type: true, anti_virus: true

    def required?
      !request.for_self?
    end

    def saveable_attributes
      attrs = attributes.clone
      attrs.delete("letter_of_consent_id") if letter_of_consent_id.nil? || letter_of_consent.present?
      attrs.delete("letter_of_consent") if letter_of_consent.nil?
      attrs
    end

    def updateable_attributes
      attributes.except("letter_of_consent")
    end
  end
end
