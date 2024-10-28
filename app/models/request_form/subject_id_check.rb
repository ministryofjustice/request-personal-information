module RequestForm
  class SubjectIdCheck < Base
    OPTIONS = {
      "yes": "Yes, add these uploads",
      "no": "No, I want to choose different uploads",
    }.freeze

    attr_accessor :default, :subject_id_check

    validates :subject_id_check, presence: true
    validate  :valid_file_type, :check_value

    def required?
      !request.by_solicitor?
    end

  private

    def check_value
      if subject_id_check == "no"
        attachment_id = Attachment.find(request.subject_photo_id)
        attachment_id.destroy!
        request.subject_photo_id = nil
        attachment_proof = Attachment.find(request.subject_proof_of_address_id)
        attachment_proof.destroy!
        request.subject_proof_of_address_id = nil


      end
    end

    def valid_file_type
      if subject_id_check.present?
        allowed_types = %w[.jpg .jpeg .png .pdf .doc .docx]
        attachment_id = Attachment.find(request.subject_photo_id)
        unless allowed_types.any? { |ext| attachment_id.filename.end_with?(ext) }
          errors.add(:subject_id_check, :invalid_file_type)
        end
        attachment_proof = Attachment.find(request.subject_proof_of_address_id)
        unless allowed_types.any? { |ext| attachment_proof.filename.end_with?(ext) }
          errors.add(:subject_id_check, :invalid_file_type)
        end
      end
    end
  end
end
