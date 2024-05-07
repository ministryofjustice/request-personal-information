class RequestsController < ApplicationController
  STEPS = %i[
    subject
    subject-name
    subject-date-of-birth
    subject-relationship
    solicitor-details
    requester-details
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
      @information_request.assign_attributes(request_params)
      session[:information_request] = @information_request.to_hash
      next_step
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
