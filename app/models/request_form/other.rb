module RequestForm
  class Other < Base
    attribute :moj_other_text

    validates :moj_other_text, presence: true

    def required?
      request.moj_other
    end
  end
end
