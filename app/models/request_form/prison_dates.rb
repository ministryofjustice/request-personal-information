module RequestForm
  class PrisonDates < Base
    include ActiveRecord::AttributeAssignment

    attribute :prison_date_from, :date
    attribute :prison_date_to, :date

    attr_reader :invalid_date_from, :invalid_date_to

    validate :valid_dates

    def prison_date_from=(value)
      @prison_date_from = ActiveRecord::Type::Date.new.cast(value)
      @invalid_date_from = true if @prison_date_from.nil? && value&.any?(&:present?)
      super
    end

    def prison_date_to=(value)
      @prison_date_to = ActiveRecord::Type::Date.new.cast(value)
      @invalid_date_to = true if @prison_date_to.nil? && value&.any?(&:present?)
      super
    end

    def required?
      request.prison_service
    end

  private

    def valid_dates
      errors.add(:prison_date_from, :invalid) if invalid_date_from
      errors.add(:prison_date_to, :invalid) if invalid_date_to
    end
  end
end
