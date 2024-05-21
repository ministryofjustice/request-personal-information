module RequestForm
  class Opg < Base
    attribute :opg_text

    validates :opg_text, presence: true

    def required?
      request.opg
    end
  end
end
