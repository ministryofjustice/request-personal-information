module MailHelper
  def format_information(information)
    if information.present?
      information.split("<br>")
    end
  end
end
