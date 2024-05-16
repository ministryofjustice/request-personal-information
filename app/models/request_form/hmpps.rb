module RequestForm
  class Hmpps < Base
    attribute :prison_service
    attribute :probation_service
    attribute :hmpps_information
    attr_accessor :default, :hmpps

    validates :hmpps_information, presence: true
    validates :hmpps, presence: true, if: -> { hmpps_information == "yes" && prison_service.blank? && probation_service.blank?  }

    def assign_attributes(values)
      # ensure boolean values
      values[:prison_service] = (values[:prison_service] == "true")
      values[:probation_service] = (values[:probation_service] == "true")
      super
    end
  end
end
