module RequestForm
  class SubjectIdCheck < Base
    OPTIONS = {
      "yes": "Yes, add these uploads",
      "no": "No, I want to choose different uploads",
    }.freeze

    attr_accessor :default, :subject_id_check

    validates :subject_id_check, presence: true
    validate  :valid_file_type



    def required?
      !request.by_solicitor?
    end

  private

    def check_value
      if subject_id_check == "no"
        attachment_id = Attachment.find(request.subject_photo_id)
        attachment_id.destroy!
        request.subject_photo_id = nil
        self.back = true
      end
    end

    def valid_file_type
      if subject_id_check.present?
        allowed_types = %w[.jpg .jpeg .png .pdf .doc .docx]
        puts allowed_types
        attachment_id = Attachment.find(request.subject_photo_id)
        unless allowed_types.any? { |ext| attachment_id.filename.end_with?(ext) }
          errors.add(:subject_id_check, :invalid_file_type )
        end
      end
    end
  end
end
