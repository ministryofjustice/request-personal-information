class RequestsController < ApplicationController
  STEPS = %i[
    subject
    subject-name
    subject-date-of-birth
    subject-relationship
    solicitor-details
    requester-details
    letter-of-consent
    letter-of-consent-check
    requester-id
    requester-id-check
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

    if @form.valid?
      @information_request.assign_attributes(@form.attributes)
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
    @form.request = @information_request
  end

  def request_params
    params.require(:request_form).permit(
      :subject,
      :full_name,
      :other_names,
      :date_of_birth_dd,
      :date_of_birth_mm,
      :date_of_birth_yyyy,
      :relationship,
      :organisation_name,
      :requester_name,
      :letter_of_consent,
      :letter_of_consent_check,
      :requester_photo,
      :requester_proof_of_address,
      :requester_id_check,
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
