module RequestForm
  class Moj < Base
    attribute :prison_service
    attribute :probation_service
    attribute :laa
    attribute :opg
    attribute :moj_other
    attribute :moj_other_where
    attr_accessor :moj

    validates :moj, presence: true, if: -> { prison_service.blank? && probation_service.blank? && laa.blank? && opg.blank? && moj_other.blank? }
    validates :moj_other_where, presence: true, if: -> { moj_other.present? }

    def assign_attributes(values)
      # ensure boolean values
      values[:prison_service] = (values[:prison_service] == "true")
      values[:probation_service] = (values[:probation_service] == "true")
      values[:laa] = (values[:laa] == "true")
      values[:opg] = (values[:opg] == "true")
      values[:moj_other] = (values[:moj_other] == "true")
      super
    end
  end
end
