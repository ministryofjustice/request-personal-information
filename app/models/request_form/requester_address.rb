module RequestForm
  class RequesterAddress < Base
    attribute :requester_proof_of_address
    attribute :requester_proof_of_address_id
    attr_accessor :default

    validates :requester_proof_of_address, presence: true, antivirus: true, unless: -> { Attachment.exists?(requester_proof_of_address_id) }
    validates :requester_proof_of_address, file_size: { max: 7.megabytes }, file_type: true, anti_virus: true

    def required?
      request.by_family_or_friend?
    end

    def saveable_attributes
      attrs = attributes.clone
      attrs.delete("requester_proof_of_address_id") if requester_proof_of_address_id.nil? || requester_proof_of_address.present?
      attrs.delete("requester_proof_of_address") if requester_proof_of_address.nil?
      attrs
    end

    def updateable_attributes
      attributes.except("requester_proof_of_address")
    end
  end
end
