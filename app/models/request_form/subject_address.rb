module RequestForm
  class SubjectAddress < Base
    attribute :subject_proof_of_address
    attribute :subject_proof_of_address_id
    attr_accessor :default

    validates :subject_proof_of_address, presence: true, unless: -> { Attachment.exists?(subject_proof_of_address_id) }
    validates :subject_proof_of_address, file_size: { max: 7.megabytes }, file_type: true, anti_virus: true

    def required?
      !request.by_solicitor?
    end

    def saveable_attributes
      attrs = attributes.clone
      attrs.delete("subject_proof_of_address_id") if subject_proof_of_address_id.nil? || subject_proof_of_address.present?
      attrs.delete("subject_proof_of_address") if subject_proof_of_address.nil?
      attrs
    end

    def updateable_attributes
      attributes.except("subject_proof_of_address")
    end
  end
end
