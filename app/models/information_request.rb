class InformationRequest < ApplicationRecord
  acts_as_gov_uk_date :date_of_birth

  attr_accessor :date_of_birth, :relationship, :organisation_name, :requester_name, :letter_of_consent_id

  belongs_to :letter_of_consent, class_name: "Attachment"

  def for_self?
    subject == "self"
  end

  def solicitor_request?
    !for_self? && relationship == "legal_representative"
  end

  def possessive_pronoun
    for_self? ? "your" : "their"
  end

  def letter_of_consent=(file)
    file_object = Attachment.create(file:, key: "letter_of_consent")
    self.letter_of_consent_id = file_object.id
  end

  def to_hash
    {
      subject:,
      full_name:,
      other_names:,
      date_of_birth:,
      relationship:,
      organisation_name:,
      requester_name:,
      letter_of_consent_id:,
    }
  end
end
