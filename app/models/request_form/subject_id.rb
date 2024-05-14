module RequestForm
  class SubjectId < Base
    attribute :subject_photo
    attribute :subject_proof_of_address

    attr_accessor :default

    validates :subject_photo, presence: true, file_size: { max: 7.megabytes }
    validates :subject_proof_of_address, presence: true, file_size: { max: 7.megabytes }

    def required?
      !request.solicitor_request?
    end
  end
end
