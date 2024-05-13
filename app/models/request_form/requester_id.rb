module RequestForm
  class RequesterId < Base
    attribute :requester_photo
    attribute :requester_proof_of_address

    attr_accessor :default

    validates :requester_photo, presence: true, file_size: { max: 7.megabytes }
    validates :requester_proof_of_address, presence: true, file_size: { max: 7.megabytes }

    def required?
      !request.for_self? && !request.solicitor_request?
    end
  end
end
