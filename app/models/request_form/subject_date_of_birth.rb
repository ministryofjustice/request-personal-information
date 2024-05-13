module RequestForm
  class SubjectDateOfBirth < Base
    include ActiveRecord::AttributeAssignment

    attribute :date_of_birth, :date

    validates :date_of_birth, presence: {
      message: lambda do |object, data|
        "Enter #{object.request.possessive_pronoun} #{data[:attribute].downcase}"
      end,
    }
  end
end
