module RequestForm
  class SubjectDateOfBirth < Base
    include ActiveRecord::AttributeAssignment
    include Dateable

    attribute :date_of_birth, :date
    date_for_form :date_of_birth

    validate :check_date_of_birth_presence
    validate :check_date_of_birth
  end
end
