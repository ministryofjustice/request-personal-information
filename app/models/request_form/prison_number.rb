module RequestForm
  class PrisonNumber < Base
    attribute :prison_number, :string

    validates :prison_number, presence: true, unless: -> { @request.for_self? }

    def required?
      request.prison_service
    end
  end
end
