class RequestsController < ApplicationController
  STEPS = %i[
    subject
    subject-name
    subject-date-of-birth
    subject-relationship
    solicitor-details
    requester-details
    requester-id
    requester-id-check
    letter-of-consent
    letter-of-consent-check
    subject-id
    subject-address
    subject-id-check
    moj
    prison-location
    prison-number
    prison-information
    prison-dates
    probation-location
    probation-information
    probation-dates
    laa
    laa-dates
    opg
    opg-dates
    other-where
    other
    other-dates
    contact-address
    contact-email
    upcoming
  ].freeze

  before_action :enable_back_button

  def new
    reset_session
    redirect_to "/#{STEPS.first}"
  end

  def show
    redirect_to root_path and return if session[:history].nil?

    unless session[:history].include?(requested_step)
      redirect_to "/#{session[:current_step]}" and return
    end

    @information_request = InformationRequest.new(session[:information_request])

    unless @information_request.valid?
      # Force the user to complete the form again if it's not valid
      session[:history] = [STEPS.first]
      redirect_to "/#{STEPS.first}" and return
    end

    @summary = @information_request.summary
  end

  def edit
    redirect_to root_path and return if session[:history].nil?

    unless session[:history].include?(requested_step)
      redirect_to "/#{session[:current_step]}" and return
    end

    session[:current_step] = requested_step
    set_objects
    next_step unless @form.required?
  end

  def update
    redirect_to root_path and return if session[:current_step].nil?

    set_objects
    @form.assign_attributes(request_params)

    @information_request.assign_attributes(@form.saveable_attributes)
    set_form_attributes

    if @form.valid?
      session[:information_request] = @information_request.to_hash
      @form.back.nil? ? next_step : previous_step(@form.back)
    else
      render :edit
    end
  end

  def create
    redirect_to root_path and return if session[:current_step].nil?

    information_request = InformationRequest.new(session[:information_request])
    begin
      information_request.save!
      NewRequestJob.perform_later(information_request)
      reset_session
      redirect_to "/form-sent" and return
    rescue StandardError => e
      Sentry.capture_message(e.message)
      # Force the user to complete the form again if it's not valid
      session[:history] = [STEPS.first]
      redirect_to "/#{STEPS.first}" and return
    end
  end

  def back
    @information_request = InformationRequest.new(session[:information_request])
    previous_step
  end

  def complete; end

private

  def enable_back_button
    response.headers["Cache-Control"] = "no-store, no-cache"
  end

  def requested_step
    request.env["PATH_INFO"][1..]
  end

  def set_objects
    @information_request = InformationRequest.new(session[:information_request])
    @form = "RequestForm::#{session[:current_step].underscore.camelize}".constantize.new(request: @information_request)
    set_form_attributes
  end

  def set_form_attributes
    @form.updateable_attributes.each_key do |att|
      @form.send("#{att}=", @information_request.send(att))
    end
  end

  def request_params
    params.require(:request_form).permit(
      :subject,
      :full_name,
      :other_names,
      :form_date_of_birth,
      :relationship,
      :organisation_name,
      :requester_name,
      :letter_of_consent,
      :letter_of_consent_id,
      :letter_of_consent_check,
      :requester_photo,
      :requester_photo_id,
      :requester_proof_of_address,
      :requester_proof_of_address_id,
      :requester_id_check,
      :subject_photo,
      :subject_photo_id,
      :subject_proof_of_address,
      :subject_proof_of_address_id,
      :subject_id_check,
      :hmpps_information,
      :prison_service,
      :probation_service,
      :currently_in_prison,
      :current_prison_name,
      :recent_prison_name,
      :prison_number,
      :prison_nomis_records,
      :prison_security_data,
      :prison_other_data,
      :prison_other_data_text,
      :form_prison_date_from,
      :form_prison_date_to,
      :probation_office,
      :probation_ndelius,
      :probation_other_data,
      :probation_other_data_text,
      :form_probation_date_from,
      :form_probation_date_to,
      :laa,
      :opg,
      :moj_other,
      :moj_other_where,
      :laa_text,
      :form_laa_date_from,
      :form_laa_date_to,
      :opg_text,
      :form_opg_date_from,
      :form_opg_date_to,
      :moj_other_text,
      :form_moj_other_date_from,
      :form_moj_other_date_to,
      :contact_address,
      :contact_email,
      :upcoming_court_case,
      :upcoming_court_case_text,
    )
  end

  def reset_session
    session[:current_step] = nil
    session[:information_request] = nil
    session[:history] = [STEPS.first]
  end

  def next_step
    redirect = nil
    index = current_index + 1

    if index >= STEPS.size
      step = "check-answers"
      session[:history] << step unless session[:history].include?(step)
      redirect = "/#{step}"
    else
      while redirect.nil?
        next_to_try = STEPS[index].to_s
        form = "RequestForm::#{next_to_try.underscore.camelize}".constantize.new(request: @information_request)
        if form.required?
          session[:history] << next_to_try unless session[:history].include?(next_to_try)
          redirect = "/#{next_to_try}"
        end
        index += 1
      end

    end

    redirect_to redirect and return
  end

  def previous_step(steps_back = 1)
    redirect = nil
    index = current_index - steps_back

    if index.negative?
      redirect = "/"
    else
      while redirect.nil?
        next_to_try = STEPS[index].to_s
        form = "RequestForm::#{next_to_try.underscore.camelize}".constantize.new(request: @information_request)
        if form.required? && session[:history].include?(next_to_try)
          redirect = "/#{next_to_try}"
        end
        index -= 1
      end
    end

    redirect_to redirect and return
  end

  def current_index
    STEPS.find_index(session[:current_step].to_sym)
  end
end
