module RequestForm
  class ProbationLocation < Base
    attribute :probation_office

    validates :probation_office, presence: {
      message: lambda do |object, _|
        "Enter #{object.request.possessive_pronoun} probation office or approved premises"
      end,
    }

    def required?
      request.probation_service
    end
  end
end
