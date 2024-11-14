class FileTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value

    allowed_types = options[:allowed] || %w[image/jpg image/jpeg image/png application/pdf application/doc application/docx]

    unless allowed_types.include?(value.content_type)
      record.errors.add attribute, "The selected file must be a PDF, image (jpg, .jpeg, .png) or Microsoft Word document (.doc, .docx)"
    end
  end
end
