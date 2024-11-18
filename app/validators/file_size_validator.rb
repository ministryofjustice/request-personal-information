class FileSizeValidator < ActiveModel::EachValidator
  include ActionView::Helpers::NumberHelper

  def validate_each(record, attribute, value)
    max_size = options[:max] || 7.megabytes

    return if value.nil?

    if File.size(value) > max_size
      record.errors.add attribute, "The selected file must be #{number_to_human_size(max_size)} or smaller"
    end
  end
end
