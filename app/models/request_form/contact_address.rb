module RequestForm
  class ContactAddress < Base
    attribute :contact_address

    validates :contact_address, presence: true
  end
end
