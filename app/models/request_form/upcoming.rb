module RequestForm
  class Upcoming < Base
    attribute :upcoming_court_case
    attribute :upcoming_court_case_text

    attr_accessor :default

    validates :upcoming_court_case, presence: true
    validates :upcoming_court_case_text, presence: true, if: -> { upcoming_court_case == "yes" }
  end
end
