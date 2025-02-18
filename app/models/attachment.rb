class Attachment < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  has_one_attached :file
  validates :file, antivirus: true

  before_destroy :purge_file

  def to_s
    "#{filename}, #{number_to_human_size(file.byte_size)}"
  end

  def purge_file
    file.purge_later
  end

  def filename
    file.filename.to_s
  end

  def payload
    {
      url: file.url,
      filename:,
    }
  end
end
