module RequestForm
  class PrisonData < Base

    attribute :prison_nomis_records
    attribute :prison_security_data
    attribute :other_prison_data
    attribute :other_prison_data_text
    attr_accessor :default

    def required?
      request.prison_service
    end
  end
end
