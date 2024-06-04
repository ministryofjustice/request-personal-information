module RequestForm
  class RequesterDetails < Base
    attribute :requester_name, :string

    validates :requester_name, presence: true

    def required?
      request.by_family_or_friend?
    end
  end
end
