class InformationRequest < ApplicationRecord
  attr_accessor :date_of_birth, :relationship, :organisation_name, :requester_name,
                :letter_of_consent_id, :requester_photo_id, :requester_proof_of_address_id,
                :subject_photo_id, :subject_proof_of_address_id, :prison_service, :probation_service, :hmpps_information

  belongs_to :letter_of_consent, class_name: "Attachment"
  belongs_to :requester_photo, class_name: "Attachment"
  belongs_to :requester_proof_of_address, class_name: "Attachment"
  belongs_to :subject_photo, class_name: "Attachment"
  belongs_to :subject_proof_of_address, class_name: "Attachment"

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
    file_object = Attachment.create!(file:, key: "letter_of_consent")
    self.letter_of_consent_id = file_object.id
  end

  def requester_photo=(file)
    file_object = Attachment.create!(file:, key: "requester_photo")
    self.requester_photo_id = file_object.id
  end

  def requester_proof_of_address=(file)
    file_object = Attachment.create!(file:, key: "requester_proof_of_address")
    self.requester_proof_of_address_id = file_object.id
  end

  def subject_photo=(file)
    file_object = Attachment.create!(file:, key: "subject_photo")
    self.subject_photo_id = file_object.id
  end

  def subject_proof_of_address=(file)
    file_object = Attachment.create!(file:, key: "subject_proof_of_address")
    self.subject_proof_of_address_id = file_object.id
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
      requester_photo_id:,
      requester_proof_of_address_id:,
      subject_photo_id:,
      subject_proof_of_address_id:,
      hmpps_information:,
      prison_service:,
      probation_service:,
    }
  end
end
