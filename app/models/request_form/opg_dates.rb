module RequestForm
  class OpgDates < Base
    include ActiveRecord::AttributeAssignment

    attribute :opg_date_from, :date
    attribute :opg_date_to, :date

    attr_reader :invalid_date_from, :invalid_date_to

    validate :valid_dates

    def opg_date_from=(value)
      @opg_date_from = ActiveRecord::Type::Date.new.cast(value)
      @invalid_date_from = true if @opg_date_from.nil? && value&.any?(&:present?)
      super
    end

    def opg_date_to=(value)
      @opg_date_to = ActiveRecord::Type::Date.new.cast(value)
      @invalid_date_to = true if @opg_date_to.nil? && value&.any?(&:present?)
      super
    end

    def required?
      request.opg
    end

  private

    def valid_dates
      errors.add(:opg_date_from, :invalid) if invalid_date_from
      errors.add(:opg_date_to, :invalid) if invalid_date_to
    end
  end
end
