class InformationRequest < ApplicationRecord
  belongs_to :letter_of_consent, class_name: "Attachment", optional: true
  belongs_to :requester_photo, class_name: "Attachment", optional: true
  belongs_to :requester_proof_of_address, class_name: "Attachment", optional: true
  belongs_to :subject_photo, class_name: "Attachment", optional: true
  belongs_to :subject_proof_of_address, class_name: "Attachment", optional: true

  validates :subject, presence: true
  validates :date_of_birth, presence: true
  validates :full_name, presence: true
  validates :relationship, presence: true, unless: -> { for_self? }
  validates :organisation_name, presence: true, if: -> { by_solicitor? }
  validates :requester_name, presence: true, if: -> { by_family_or_friend? }
  validates :requester_photo_id, presence: true, if: -> { by_family_or_friend? }
  validates :requester_proof_of_address_id, presence: true, if: -> { by_family_or_friend? }
  validates :letter_of_consent_id, presence: true, unless: -> { for_self? }
  validates :subject_photo_id, presence: true, unless: -> { by_solicitor? }
  validates :subject_proof_of_address_id, presence: true, unless: -> { by_solicitor? }
  validates :moj_other_where, presence: true, if: -> { moj_other.present? }
  validates :currently_in_prison, presence: true, if: -> { prison_service? && !for_self? }
  validates :current_prison_name, presence: true, if: -> { prison_service? && currently_in_prison == "yes" }
  validates :recent_prison_name, presence: true, if: -> { prison_service? && (currently_in_prison == "no" || for_self?) }
  validates :prison_number, presence: true, if: -> { prison_service? && !for_self? }
  validates :prison_other_data_text, presence: true, if: -> { prison_service? && prison_other_data.present? }
  validates :probation_office, presence: true, if: -> { probation_service? }
  validates :probation_other_data_text, presence: true, if: -> { probation_service? && probation_other_data.present? }
  validates :laa_text, presence: true, if: -> { laa? }
  validates :opg_text, presence: true, if: -> { opg? }
  validates :moj_other_text, presence: true, if: -> { moj_other? }
  validates :contact_address, presence: true
  validates :contact_email, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :upcoming_court_case, presence: true
  validates :upcoming_court_case_text, presence: true, if: -> { upcoming_court_case == "yes" }
  validates :submission_id, presence: true

  before_validation :set_submission_id

  def for_self?
    subject == "self"
  end

  def by_solicitor?
    !for_self? && relationship == "legal_representative"
  end

  def by_family_or_friend?
    !for_self? && relationship == "other"
  end

  def pronoun
    for_self? ? "you" : "they"
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

  def information_required
    info = []
    info << "Prison Service" if prison_service?
    info << "Probation Service" if probation_service?
    info << "Legal Aid Agency" if laa?
    info << "Office of the Public Guardian (OPG)" if opg?
    info << "Somewhere else in the Ministry of Justice" if moj_other?
    info.join("\cr\n")
  end

  def prison_information
    info = []
    info << "NOMIS Records" if prison_nomis_records?
    info << "Security data" if prison_security_data?
    info << "Something else" if prison_other_data?
    info.join("\cr\n")
  end

  def probation_information
    info = []
    info << "nDelius file" if probation_ndelius?
    info << "Something else" if probation_other_data?
    info.join("\cr\n")
  end

  def summary
    summary = InformationRequestSummary.new(self)
    {
      subject_summary: summary.subject,
      requester_summary: summary.requester,
      requester_id_summary: summary.requester_id,
      subject_id_summary: summary.subject_id,
      information_summary: summary.information,
      prison_summary: summary.prison,
      probation_summary: summary.probation,
      laa_summary: summary.laa,
      opg_summary: summary.opg,
      moj_other_summary: summary.moj_other,
      contact_summary: summary.contact,
    }
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
      currently_in_prison:,
      current_prison_name:,
      recent_prison_name:,
      prison_number:,
      prison_nomis_records:,
      prison_security_data:,
      prison_other_data:,
      prison_other_data_text:,
      prison_date_from:,
      prison_date_to:,
      probation_office:,
      probation_ndelius:,
      probation_other_data:,
      probation_other_data_text:,
      probation_date_from:,
      probation_date_to:,
      laa:,
      opg:,
      moj_other:,
      moj_other_where:,
      laa_text:,
      laa_date_from:,
      laa_date_to:,
      opg_text:,
      opg_date_from:,
      opg_date_to:,
      moj_other_text:,
      moj_other_date_from:,
      moj_other_date_to:,
      contact_address:,
      contact_email:,
      upcoming_court_case:,
      upcoming_court_case_text:,
    }
  end

  def payload
    InformationRequestPayload.new(self).call
  end

private

  def set_submission_id
    self.submission_id ||= SecureRandom.uuid
  end
end
