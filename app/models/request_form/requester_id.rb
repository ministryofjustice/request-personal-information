module RequestForm
  class RequesterId < Base
    attribute :requester_photo
    attribute :requester_photo_id
    attribute :requester_proof_of_address
    attribute :requester_proof_of_address_id
    attr_accessor :default

    validates :requester_photo, presence: true, unless: -> { Attachment.exists?(requester_photo_id) }
    validates :requester_photo, file_size: { max: 7.megabytes }
    validates :requester_proof_of_address, presence: true, unless: -> { Attachment.exists?(requester_proof_of_address_id) }
    validates :requester_proof_of_address, file_size: { max: 7.megabytes }

    def required?
      !request.for_self? && !request.solicitor_request?
    end

    def saveable_attributes
      attrs = attributes.clone
      attrs.delete("requester_photo_id") if requester_photo_id.nil? || requester_photo.present?
      attrs.delete("requester_proof_of_address_id") if requester_proof_of_address_id.nil? || requester_proof_of_address.present?
      attrs.delete("requester_photo") if requester_photo.nil?
      attrs.delete("requester_proof_of_address") if requester_proof_of_address.nil?
      attrs
    end

    def updateable_attributes
      attributes.except("requester_photo", "requester_proof_of_address")
    end
  end
end
