module RequestForm
  class SubjectDateOfBirth < Base
    include GovUkDateFields::ActsAsGovUkDate

    attribute :date_of_birth, :date
    acts_as_gov_uk_date :date_of_birth

    validates :date_of_birth, presence: {
      message: lambda do |object, data|
        "Enter #{object.request.possessive_pronoun} #{data[:attribute].downcase}"
      end,
    }
  end
end
