module RequestForm
  class SubjectName < Base
    attr_accessor :full_name, :other_names

    validates :full_name, presence: {
      message: lambda do |object, data|
        "Enter #{object.request.possessive_pronoun} #{data[:attribute].downcase}"
      end,
    }
  end
end
