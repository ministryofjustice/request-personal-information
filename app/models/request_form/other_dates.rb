module RequestForm
  class OtherDates < Base
    include ActiveRecord::AttributeAssignment
    include Dateable

    attribute :moj_other_date_from, :date
    attribute :moj_other_date_to, :date

    date_for_form :moj_other_date_from
    date_for_form :moj_other_date_to

    validate :check_moj_other_date_from
    validate :check_moj_other_date_to

    def required?
      request.moj_other
    end
  end
end
