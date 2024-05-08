module RequestForm
  class RequesterDetails < Base
    attr_accessor :requester_name

    validates :requester_name, presence: true

    def required?
      !request.for_self? && !request.solicitor_request?
    end
  end
end
