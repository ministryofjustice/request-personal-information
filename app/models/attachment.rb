class Attachment < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  has_one_attached :file

  before_destroy :purge_file

  delegate :filename, to: file

  def to_s
    "#{file.filename}, #{number_to_human_size(file.byte_size)}"
  end

  def purge_file
    file.purge_later
  end

  def payload
    {
      url: file.url,
      filename: file.filename,
    }
  end
end
