module RequestForm
  class RequesterIdCheck < Base
    OPTIONS = {
      "yes": "Yes, add these uploads",
      "no": "No, I want to choose different uploads",
    }.freeze

    attr_accessor :default, :requester_id_check

    validates :requester_id_check, presence: true
    validate :check_value

    def required?
      !request.for_self? && !request.by_solicitor?
    end

  private

    def check_value
      if requester_id_check == "no"
        attachment_id = Attachment.find(request.requester_photo_id)
        attachment_id.destroy!
        request.requester_photo_id = nil
        attachment_proof = Attachment.find(request.requester_proof_of_address_id)
        attachment_proof.destroy!
        request.requester_proof_of_address_id = nil

        self.back = true
      end
    end
  end
end
