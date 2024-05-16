module RequestForm
  class SubjectId < Base
    attribute :subject_photo
    attribute :subject_photo_id
    attribute :subject_proof_of_address
    attribute :subject_proof_of_address_id
    attr_accessor :default

    validates :subject_photo, presence: true, unless: -> { Attachment.exists?(subject_photo_id) }
    validates :subject_photo, file_size: { max: 7.megabytes }
    validates :subject_proof_of_address, presence: true, unless: -> { Attachment.exists?(subject_proof_of_address_id) }
    validates :subject_proof_of_address, file_size: { max: 7.megabytes }

    def required?
      !request.solicitor_request?
    end

    def saveable_attributes
      attrs = attributes.clone
      attrs.delete("subject_photo_id") if subject_photo_id.nil? || subject_photo.present?
      attrs.delete("subject_proof_of_address_id") if subject_proof_of_address_id.nil? || subject_proof_of_address.present?
      attrs.delete("subject_photo") if subject_photo.nil?
      attrs.delete("subject_proof_of_address") if subject_proof_of_address.nil?
      attrs
    end
  end
end
