module RequestForm
  class LetterOfConsentCheck < Base
    attr_accessor :default

    def required?
      request.by_solicitor?
    end
  end
end
