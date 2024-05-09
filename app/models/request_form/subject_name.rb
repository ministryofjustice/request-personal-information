module RequestForm
  class SubjectName < Base
    attribute :full_name, :string
    attribute :other_names, :string

    validates :full_name, presence: {
      message: lambda do |object, data|
        "Enter #{object.request.possessive_pronoun} #{data[:attribute].downcase}"
      end,
    }
  end
end
