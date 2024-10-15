module RequestForm
  class OtherWhere < Base
    attribute :moj_other_where

    validates :moj_other_where, presence: true

    def required?
      request.moj_other
    end
  end
end
