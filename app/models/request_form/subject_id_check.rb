module RequestForm
  class SubjectIdCheck < Base
    attr_accessor :default

    def required?
      !request.by_solicitor?
    end
  end
end
