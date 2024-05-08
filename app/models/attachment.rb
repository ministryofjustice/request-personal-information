class Attachment < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  has_one_attached :file

  def to_s
    "#{file.filename}, #{number_to_human_size(file.byte_size)}"
  end
end
