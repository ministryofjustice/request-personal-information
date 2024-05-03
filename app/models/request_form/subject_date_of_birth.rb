module RequestForm
  class SubjectDateOfBirth < Base
    attr_accessor :date_of_birth

    validates :date_of_birth, presence: {
      message: lambda do |object, data|
        "Enter #{object.request.possessive_pronoun} #{data[:attribute].downcase}"
      end,
    }
  end
end
