module RequestForm
  class ContactEmail < Base
    attribute :contact_email

    validates :contact_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  end
end
