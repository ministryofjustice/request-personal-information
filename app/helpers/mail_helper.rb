module MailHelper
  def split_list(list)
    return [] if list.blank?

    list&.split("<br>")
  end
end
