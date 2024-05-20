module RequestForm
  class Moj < Base
    attribute :laa
    attribute :opg
    attribute :moj_other
    attribute :moj_other_text
    attr_accessor :default, :moj

    validates :moj, presence: true, if: -> { !request.prison_service && !request.probation_service && laa.blank? && opg.blank? && moj_other.blank? }
    validates :moj_other_text, presence: true, if: -> { moj_other.present? }

    def assign_attributes(values)
      # ensure boolean values
      values[:laa] = (values[:laa] == "true")
      values[:opg] = (values[:opg] == "true")
      values[:moj_other] = (values[:moj_other] == "true")
      super
    end
  end
end
