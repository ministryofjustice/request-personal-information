module RequestForm
  class Subject < Base
    OPTIONS = {
      "self": "Your own",
      "other": "Someone else's",
    }.freeze

    attr_accessor :subject, :default

    validates :subject, presence: true
  end
end
