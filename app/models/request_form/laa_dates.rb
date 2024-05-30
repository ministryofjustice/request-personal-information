module RequestForm
  class LaaDates < Base
    include ActiveRecord::AttributeAssignment
    include Dateable

    attribute :laa_date_from, :date
    attribute :laa_date_to, :date

    date_for_form :laa_date_from
    date_for_form :laa_date_to

    validate :check_laa_date_from
    validate :check_laa_date_to

    def required?
      request.laa
    end
  end
end
