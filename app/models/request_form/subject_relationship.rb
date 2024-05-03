module RequestForm
  class SubjectRelationship < Base
    OPTIONS = {
      "legal_representative": "Legal Representative",
      "other": "Relative, friend or something else",
    }.freeze

    attr_accessor :relationship

    validates :relationship, presence: true

    def required?
      !request.for_self?
    end
  end
end
