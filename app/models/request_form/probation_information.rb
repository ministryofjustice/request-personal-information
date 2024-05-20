module RequestForm
  class ProbationInformation < Base
    attribute :probation_ndelius
    attribute :probation_other_data
    attribute :probation_other_data_text
    attr_accessor :default, :probation_data

    validates :probation_data, presence: true, if: -> { probation_ndelius.blank? && probation_other_data.blank? }
    validates :probation_other_data_text, presence: true, if: -> { probation_other_data.present? }

    def assign_attributes(values)
      # ensure boolean values
      values[:probation_ndelius] = (values[:probation_ndelius] == "true")
      values[:probation_other_data] = (values[:probation_other_data] == "true")
      super
    end

    def required?
      request.probation_service
    end
  end
end
