module RequestForm
  class PrisonDates < Base
    include ActiveRecord::AttributeAssignment
    include Dateable

    attribute :prison_date_from, :date
    attribute :prison_date_to, :date

    date_for_form :prison_date_from
    date_for_form :prison_date_to

    validate :check_prison_date_from
    validate :check_prison_date_to

    def required?
      request.prison_service
    end
  end
end
