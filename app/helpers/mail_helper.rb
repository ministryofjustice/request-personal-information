module MailHelper
  def format_information(information)
    return [] if information.blank?

    information&.split("<br>")
  end
end
