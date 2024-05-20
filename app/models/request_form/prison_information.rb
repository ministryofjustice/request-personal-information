module RequestForm
  class PrisonInformation < Base
    attribute :prison_nomis_records
    attribute :prison_security_data
    attribute :prison_other_data
    attribute :prison_other_data_text
    attr_accessor :default, :prison_data

    validates :prison_data, presence: true, if: -> { prison_nomis_records.blank? && prison_security_data.blank? && prison_other_data.blank? }
    validates :prison_other_data_text, presence: true, if: -> { prison_other_data.present? }

    def assign_attributes(values)
      # ensure boolean values
      values[:prison_nomis_records] = (values[:prison_nomis_records] == "true")
      values[:prison_security_data] = (values[:prison_security_data] == "true")
      values[:prison_other_data] = (values[:prison_other_data] == "true")
      super
    end

    def required?
      request.prison_service
    end
  end
end
