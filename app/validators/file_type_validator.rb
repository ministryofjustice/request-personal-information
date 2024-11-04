 class FileTypeValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      return unless value
      debugger

      allowed_types = options[:allowed] ||  %w[image/jpg image/jpeg image/png application/pdf application/doc application/docx]

      if !allowed_types.include?(value.content_type)
        record.errors.add(attribute, :invalid_file_type)
      end
    end
  end
