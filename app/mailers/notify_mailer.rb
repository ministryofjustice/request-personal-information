class NotifyMailer < ApplicationMailer
  helper :mail
  def new_request(request)
    @information_request = request
    @summary = request.summary
    view_mail("ed38a7b5-d9d1-44a5-bdc3-0a3319fa54c6", to: request.contact_email, subject: "Request Personal Information")
  end
end
