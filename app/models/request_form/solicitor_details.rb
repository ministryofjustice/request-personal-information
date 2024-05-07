module RequestForm
  class SolicitorDetails < Base
    attr_accessor :organisation_name, :requester_name

    validates :organisation_name, presence: true
  end
end
