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
    subject-id-check
    hmpps
    prison-location
    prison-number
    prison-information
    prison-dates
    probation-location
    probation-information
    probation-dates
  ].freeze

  before_action :set_objects, only: %i[update show]

  def new
    reset_session
    redirect_to "/#{STEPS.first}"
  end

  def show
    next_step(skipping: true) unless @form.required?
  end

  def update
    @form.assign_attributes(request_params)
    @information_request.assign_attributes(@form.saveable_attributes)
    set_form_attributes

    if @form.valid?
      session[:information_request] = @information_request.to_hash
      @form.back.nil? ? next_step : previous_step
    else
      render :show
    end
  end

  def back
    previous_step
  end

private

  def set_objects
    redirect_to root_path and return if session[:current_step].nil?

    @information_request = InformationRequest.new(session[:information_request])
    @form = "RequestForm::#{session[:current_step].underscore.camelize}".constantize.new
    set_form_attributes
    @form.request = @information_request
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
      :date_of_birth,
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
      :prison_date_from,
      :prison_date_to,
      :probation_office,
      :probation_ndelius,
      :probation_other_data,
      :probation_other_data_text,
      :probation_date_from,
      :probation_date_to,
    )
  end

  def reset_session
    session[:information_request] = nil
    session[:current_step] = STEPS.first
    session[:history] = ["/"]
  end

  def next_step(skipping: false)
    session[:history] << "/#{session[:current_step]}" unless skipping
    session[:current_step] = STEPS[current_index + 1]
    redirect_to "/#{session[:current_step]}"
  end

  def previous_step
    previous = session[:history].pop
    session[:current_step] = previous.tr("/", "")
    redirect_to previous
  end

  def current_index
    STEPS.find_index(session[:current_step].to_sym)
  end
end
