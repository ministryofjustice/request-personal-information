class NotifyMailer < ApplicationMailer
  helper :mail
  def new_request(request)
    @information_request = request
    @summary = request.summary

    forwarding_department = if request.probation_service? || request.prison_service?
                              "nick.preddy @justice.gov.uk"
                            else
                              "nick.preddy @digital.Justice.gov.uk"
                            end

    # view_mail("ed38a7b5-d9d1-44a5-bdc3-0a3319fa54c6", to: request.contact_email, subject: "Submission from Request personal information #{@information_request.full_name} DoB #{@information_request.date_of_birth.strftime('%d/%m/%Y')}")
    view_mail("ed38a7b5-d9d1-44a5-bdc3-0a3319fa54c6", to: forwarding_department, subject: "Submission from Request personal information #{@information_request.full_name} DoB #{@information_request.date_of_birth.strftime('%d/%m/%Y')}")
  end
end
