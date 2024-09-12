module RequestForm
  class Subject < Base
    OPTIONS = {
      "self": "My own",
      "other": "Someone else's",
    }.freeze

    attribute :subject, :string
    attr_accessor :default

    validates :subject, presence: true
  end
end
