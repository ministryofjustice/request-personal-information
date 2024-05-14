module RequestForm
  class SubjectId < Base
    attribute :subject_photo
    attribute :subject_photo_id
    attribute :subject_proof_of_address
    attribute :subject_proof_of_address_id
    attr_accessor :default

    validates :subject_photo,
              presence: true,
              file_size: { max: 7.megabytes },
              unless: -> { Attachment.exists?(subject_photo_id) }
    validates :subject_proof_of_address,
              presence: true,
              file_size: { max: 7.megabytes },
              unless: -> { Attachment.exists?(subject_proof_of_address_id) }

    def required?
      !request.solicitor_request?
    end

    def saveable_attributes
      attrs = attributes.except("subject_photo_id", "subject_proof_of_address_id")
      attrs.delete("subject_photo") if subject_photo.nil?
      attrs.delete("subject_proof_of_address") if subject_proof_of_address.nil?
      attrs
    end
  end
end
