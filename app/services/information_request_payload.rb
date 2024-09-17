class InformationRequestPayload
  # Values for SUBJECT[:self], SUBJECT_RELATIONSHIP[:legal_representative] and "yes" for booleans
  # are required by the API this payload is sent to.
  # Therefore they shouldn't be changed.
  SUBJECT = {
    self: "your own",
    other: "someone else's",
  }.freeze

  SUBJECT_RELATIONSHIP = {
    legal_representative: "legal representative",
    other: "relative, friend or something else",
  }.freeze

  def initialize(request)
    @request = request
  end

  def call
    {
      submission_id:,
      answers:,
      attachments:,
    }
  end

private

  def submission_id
    @request.submission_id
  end

  def answers
    hash = @request.to_hash.except(:subject, :relationship, :currently_in_prison, :upcoming_court_case,
                                   :letter_of_consent_id, :requester_photo_id, :requester_proof_of_address_id, :subject_photo_id, :subject_proof_of_address_id,
                                   :prison_service, :probation_service, :laa, :opg, :moj_other,
                                   :prison_nomis_records, :prison_security_data, :prison_other_data,
                                   :probation_ndelius, :probation_other_data)
    hash[:subject] = SUBJECT[@request.subject.to_sym]
    hash[:relationship] = @request.relationship.present? ? SUBJECT_RELATIONSHIP[@request.relationship.to_sym] : ""
    hash[:currently_in_prison] = @request.currently_in_prison&.capitalize
    hash[:upcoming_court_case] = @request.upcoming_court_case&.capitalize
    hash[:prison_information] = @request.prison_information
    hash[:probation_information] = @request.probation_information
    hash[:letter_of_consent_file_name] = @request.letter_of_consent&.filename
    hash[:requester_photo_file_name] = @request.requester_photo&.filename
    hash[:requester_proof_of_address_file_name] = @request.requester_proof_of_address&.filename
    hash[:subject_photo_file_name] = @request.subject_photo&.filename
    hash[:subject_proof_of_address_file_name] = @request.subject_proof_of_address&.filename
    hash[:prison_service] = boolean_to_text(@request.prison_service)
    hash[:probation_service] = boolean_to_text(@request.probation_service)
    hash[:laa] = boolean_to_text(@request.laa)
    hash[:opg] = boolean_to_text(@request.opg)
    hash[:moj_other] = boolean_to_text(@request.moj_other)
    hash
  end

  def attachments
    %i[letter_of_consent requester_photo requester_proof_of_address subject_photo subject_proof_of_address].filter_map do |att|
      attachment = @request.send(att)
      next if attachment.blank?

      attachment.payload
    end
  end

  def boolean_to_text(bool)
    bool ? "Yes" : "No"
  end
end
