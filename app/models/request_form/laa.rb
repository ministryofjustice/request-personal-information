module RequestForm
  class Laa < Base
    attribute :laa_text

    validates :laa_text, presence: true

    def required?
      request.laa
    end
  end
end
