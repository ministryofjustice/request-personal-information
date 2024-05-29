module RequestForm
  class OpgDates < Base
    include ActiveRecord::AttributeAssignment
    include Dateable

    attribute :opg_date_from, :date
    attribute :opg_date_to, :date

    date_for_form :opg_date_from
    date_for_form :opg_date_to

    validate :check_opg_date_from
    validate :check_opg_date_to

    def required?
      request.opg
    end
  end
end
