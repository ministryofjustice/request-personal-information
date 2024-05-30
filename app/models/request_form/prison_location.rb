module RequestForm
  class PrisonLocation < Base
    attribute :currently_in_prison
    attribute :current_prison_name
    attribute :recent_prison_name

    attr_accessor :default

    validates :currently_in_prison, presence: true, unless: -> { @request.for_self? }
    validates :current_prison_name, presence: true, if: -> { currently_in_prison == "yes" }

    validates :recent_prison_name, presence: {
      message: lambda do |object, _|
        "Enter which prison #{object.request.pronoun} were most recently in"
      end,
    }, if: -> { currently_in_prison == "no" || @request.for_self? }

    def required?
      request.prison_service
    end
  end
end
