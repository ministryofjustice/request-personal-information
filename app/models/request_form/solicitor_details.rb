module RequestForm
  class SolicitorDetails < Base
    attr_accessor :organisation_name, :requester_name

    validates :organisation_name, presence: true

    def required?
      !request.for_self? && request.solicitor_request?
    end
  end
end
