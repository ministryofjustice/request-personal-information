module RequestForm
  class RequesterIdCheck < Base
    attr_accessor :default

    def required?
      request.by_family_or_friend?
    end
  end
end
