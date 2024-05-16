module RequestForm
  class PrisonNumber < Base
    attribute :prison_number, :string

    validates :prison_number, presence: {
      message: lambda do |object, data|
        "Enter #{object.request.possessive_pronoun} #{data[:attribute].downcase}"
      end,
    }

    def required?
      request.prison_service
    end
  end
end
