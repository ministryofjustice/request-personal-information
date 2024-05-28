module RequestForm
  class RequesterDetails < Base
    attribute :requester_name, :string

    validates :requester_name, presence: true

    def required?
      !request.for_self? && !request.by_solicitor?
    end
  end
end
