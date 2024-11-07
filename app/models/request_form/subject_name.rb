module RequestForm
  class SubjectName < Base
    attribute :full_name, :string
    attribute :other_names, :string

    validates :full_name, presence: {
      message: lambda do |object, _|
        if object.request.for_self?
          "Enter your full name"
        else
          "Enter the full name of the person whose information you are requesting"
        end
      end,
    }
  end
end
