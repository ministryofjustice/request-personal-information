module RequestForm
  class SolicitorDetails < Base
    attribute :organisation_name, :string
    attribute :requester_name, :string

    validates :organisation_name, presence: true

    def required?
      request.by_solicitor?
    end
  end
end
