module RequestForm
  class OtherDates < Base
    include ActiveRecord::AttributeAssignment

    attribute :moj_other_date_from, :date
    attribute :moj_other_date_to, :date

    attr_reader :invalid_date_from, :invalid_date_to

    validate :valid_dates

    def moj_other_date_from=(value)
      @moj_other_date_from = ActiveRecord::Type::Date.new.cast(value)
      @invalid_date_from = true if @moj_other_date_from.nil? && value&.any?(&:present?)
      super
    end

    def moj_other_date_to=(value)
      @moj_other_date_to = ActiveRecord::Type::Date.new.cast(value)
      @invalid_date_to = true if @moj_other_date_to.nil? && value&.any?(&:present?)
      super
    end

    def required?
      request.moj_other
    end

  private

    def valid_dates
      errors.add(:moj_other_date_from, :invalid) if invalid_date_from
      errors.add(:moj_other_date_to, :invalid) if invalid_date_to
    end
  end
end
