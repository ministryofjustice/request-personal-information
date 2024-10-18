module RequestForm
  class SubjectId < Base
    attribute :subject_photo
    attribute :subject_photo_id
    attr_accessor :default

    validates :subject_photo, presence: true, unless: -> { Attachment.exists?(subject_photo_id) }
    validates :subject_photo, file_size: { max: 7.megabytes }

    def required?
      !request.by_solicitor?
    end

    def saveable_attributes
      attrs = attributes.clone
      attrs.delete("subject_photo_id") if subject_photo_id.nil? || subject_photo.present?
      attrs.delete("subject_photo") if subject_photo.nil?
      attrs
    end

    def updateable_attributes
      attributes.except("subject_photo")
    end
  end
end
