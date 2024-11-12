module RequestForm
  class RequesterId < Base
    attribute :requester_photo
    attribute :requester_photo_id

    attr_accessor :default

    validates :requester_photo, presence: true, unless: -> { Attachment.exists?(requester_photo_id) }
    validates :requester_photo, file_size: { max: 7.megabytes }
    validates :requester_photo, file_type: { allowed: %w[image/jpg image/jpeg image/png application/pdf application/doc application/docx] }

    def required?
      request.by_family_or_friend?
    end

    def saveable_attributes
      attrs = attributes.clone
      attrs.delete("requester_photo_id") if requester_photo_id.nil? || requester_photo.present?
      attrs.delete("requester_photo") if requester_photo.nil?
      attrs
    end

    def updateable_attributes
      attributes.except("requester_photo")
    end
  end
end
