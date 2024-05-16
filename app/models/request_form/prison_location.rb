module RequestForm
  class PrisonLocation < Base
    attribute :currently_in_prison
    attribute :current_prison_name
    attribute :recent_prison_name

    attr_accessor :default

    validates :currently_in_prison, presence: {
      message: lambda do |object, _|
        "Choose if #{object.request.pronoun} are currently in prison"
      end,
    }

    validates :current_prison_name, presence: {
      message: lambda do |object, _|
        "Enter which prison #{object.request.pronoun} are currently in"
      end,
    }, if: -> { currently_in_prison == "yes" }

    validates :recent_prison_name, presence: {
      message: lambda do |object, _|
        "Enter which prison #{object.request.pronoun} were most recently in"
      end,
    }, if: -> { currently_in_prison == "no" }

    def required?
      request.prison_service
    end
  end
end
