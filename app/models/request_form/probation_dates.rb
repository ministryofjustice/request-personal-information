module RequestForm
  class ProbationDates < Base
    include ActiveRecord::AttributeAssignment
    include Dateable

    attribute :probation_date_from, :date
    attribute :probation_date_to, :date

    date_for_form :probation_date_from
    date_for_form :probation_date_to

    validate :check_probation_date_from
    validate :check_probation_date_to

    def required?
      request.probation_service
    end
  end
end
