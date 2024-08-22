module MailHelper
  def format_information(information)
    information&.split("<br>")
  end
end
