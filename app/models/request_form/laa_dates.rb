module RequestForm
  class LaaDates < Base
    include ActiveRecord::AttributeAssignment

    attribute :laa_date_from, :date
    attribute :laa_date_to, :date

    attr_reader :invalid_date_from, :invalid_date_to

    validate :valid_dates

    def laa_date_from=(value)
      @laa_date_from = ActiveRecord::Type::Date.new.cast(value)
      @invalid_date_from = true if @laa_date_from.nil? && value&.any?(&:present?)
      super
    end

    def laa_date_to=(value)
      @laa_date_to = ActiveRecord::Type::Date.new.cast(value)
      @invalid_date_to = true if @laa_date_to.nil? && value&.any?(&:present?)
      super
    end

    def required?
      request.laa
    end

  private

    def valid_dates
      errors.add(:laa_date_from, :invalid) if invalid_date_from
      errors.add(:laa_date_to, :invalid) if invalid_date_to
    end
  end
end
