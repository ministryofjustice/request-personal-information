module MailHelper
  def format_information(information)
    if information.length > 0
      information.split("<br>")
    else
      ""
    end
  end
end
