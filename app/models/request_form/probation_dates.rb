module RequestForm
  class ProbationDates < Base
    include ActiveRecord::AttributeAssignment

    attribute :probation_date_from, :date
    attribute :probation_date_to, :date

    attr_reader :invalid_date_from, :invalid_date_to

    validate :valid_dates

    def probation_date_from=(value)
      @probation_date_from = ActiveRecord::Type::Date.new.cast(value)
      @invalid_date_from = true if @probation_date_from.nil? && value&.any?(&:present?)
      super
    end

    def probation_date_to=(value)
      @probation_date_to = ActiveRecord::Type::Date.new.cast(value)
      @invalid_date_to = true if @probation_date_to.nil? && value&.any?(&:present?)
      super
    end

    def required?
      request.probation_service
    end

  private

    def valid_dates
      errors.add(:probation_date_from, :invalid) if invalid_date_from
      errors.add(:probation_date_to, :invalid) if invalid_date_to
    end
  end
end
