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
    other
    other-dates
    contact-address
    contact-email
    upcoming
  ].freeze

  before_action :set_objects, only: %i[edit update]

  def new
    reset_session
    redirect_to "/#{STEPS.first}"
  end

  def show
    redirect_to root_path and return if session[:current_step].nil?

    @information_request = InformationRequest.new(session[:information_request])
    @subject_summary = subject_summary
    @requester_summary = requester_summary
    @requester_id_summary = requester_id_summary
    @subject_id_summary = subject_id_summary
    @information_summary = information_summary
    @prison_summary = prison_summary
    @probation_summary = probation_summary
    @laa_summary = laa_summary
    @opg_summary = opg_summary
    @moj_other_summary = moj_other_summary
  end

  def edit
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
      render :edit
    end
  end

  def back
    previous_step(params[:step])
  end

private

  def set_objects
    redirect_to root_path and return if session[:current_step].nil?

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
      :laa,
      :opg,
      :moj_other,
      :moj_other_where,
      :laa_text,
      :laa_date_from,
      :laa_date_to,
      :opg_text,
      :opg_date_from,
      :opg_date_to,
      :moj_other_text,
      :moj_other_date_from,
      :moj_other_date_to,
      :contact_address,
      :contact_email,
      :upcoming_court_case,
      :upcoming_court_case_text,
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

  def previous_step(step_name)
    previous = nil
    loop do
      previous = session[:history].pop.tr("/", "")
      break if step_name.nil? || previous == step_name || session[:history].empty?
    end
    session[:current_step] = previous
    redirect_to "/#{session[:current_step]}"
  end

  def current_index
    STEPS.find_index(session[:current_step].to_sym)
  end

  def subject_summary
    summary = [
      {
        key: { text: t("helpers.label.request_form.full_name") },
        value: { text: @information_request.full_name },
        actions: { text: "Change", href: back_request_path("subject-name"), visually_hidden_text: t("helpers.label.request_form.full_name")},
      },
      {
        key: { text: t("helpers.label.request_form.other_names.#{@information_request.subject}") },
        value: { text: @information_request.other_names },
        actions: { text: "Change", href: back_request_path("subject-name"), visually_hidden_text: t("helpers.label.request_form.other_names.#{@information_request.subject}") },
      },
      {
        key: { text: t("request_form.subject_date_of_birth.#{@information_request.subject}") },
        value: { text: @information_request.date_of_birth },
        actions: { text: "Change", href: back_request_path("subject-date-of-birth"), visually_hidden_text: t("helpers.label.request_form.date_of_birth") },
      },
    ]

    unless @information_request.for_self?
      summary.push(
        {
          key: { text: t("request_form.subject_relationship") },
          value: { text: RequestForm::SubjectRelationship::OPTIONS[@information_request.relationship.to_sym] },
          actions: { text: "Change", href: back_request_path("subject-relationship"), visually_hidden_text: t("request_form.subject_relationship") },
        }
      )
    end

    summary
  end

  def requester_summary
    return if @information_request.for_self?

    if @information_request.by_solicitor?
      [
        {
          key: { text: t("helpers.label.request_form.organisation_name") },
          value: { text: @information_request.organisation_name },
          actions: { text: "Change", href: back_request_path("solicitor-details"), visually_hidden_text: t("helpers.label.request_form.organisation_name") },
        },
        {
          key: { text: t("helpers.label.request_form.requester_name") },
          value: { text: @information_request.requester_name },
          actions: { text: "Change", href: back_request_path("requester-name"), visually_hidden_text: t("helpers.label.request_form.requester_name") },
        },
      ]
    else
      [
        {
          key: { text: "Your full name" },
          value: { text: @information_request.requester_name },
          actions: { text: "Change", href: back_request_path("requester-name"), visually_hidden_text: t("helpers.label.request_form.requester_name") },
        },
      ]
    end
  end

  def requester_id_summary
    return if @information_request.for_self?

    summary = []

    unless @information_request.by_solicitor?
      summary.push(
        {
          key: { text: t("helpers.label.request_form.requester_photo") },
          value: { text: Attachment.find(@information_request.requester_photo_id).to_s },
          actions: { text: "Change", href: back_request_path("requester-id"), visually_hidden_text: t("helpers.label.request_form.requester_photo") },
        },
        {
          key: { text: t("helpers.label.request_form.requester_proof_of_address") },
          value: { text: Attachment.find(@information_request.requester_proof_of_address_id).to_s },
          actions: { text: "Change", href: back_request_path("requester-id"), visually_hidden_text: t("helpers.label.request_form.requester_proof_of_address") },
        }
      )
    end

    summary.push(
      {
        key: { text: t("request_form.letter_of_consent") },
        value: { text: Attachment.find(@information_request.letter_of_consent_id).to_s },
        actions: { text: "Change", href: back_request_path("letter-of-consent"), visually_hidden_text: t("request_form.letter_of_consent") },
      }
    )

    summary
  end

  def subject_id_summary
    return if @information_request.by_solicitor?

    [
      {
        key: { text: t("helpers.label.request_form.subject_photo") },
        value: { text: Attachment.find(@information_request.subject_photo_id).to_s },
        actions: { text: "Change", href: back_request_path("subject-id"), visually_hidden_text: t("helpers.label.request_form.subject_photo") },
      },
      {
        key: { text: t("helpers.label.request_form.subject_proof_of_address") },
        value: { text: Attachment.find(@information_request.subject_proof_of_address_id).to_s },
        actions: { text: "Change", href: back_request_path("subject-id"), visually_hidden_text: t("helpers.label.request_form.subject_proof_of_address") },
      },
    ]
  end

  def information_summary
    summary = [{
      key: { text: t("helpers.hint.request_form.moj") },
      value: { text: @information_request.information_required },
      actions: { text: "Change", href: back_request_path("moj"), visually_hidden_text: t("helpers.hint.request_form.moj") },
    }]

    if @information_request.moj_other.present?
      summary.push(
        {
          key: { text: t("helpers.label.request_form.moj_other_where") },
          value: { text: @information_request.moj_other_where },
          actions: { text: "Change", href: back_request_path("moj"), visually_hidden_text: t("helpers.label.request_form.moj_other_where") },
        },
      )
    end
  end

  def prison_summary
    return unless @information_request.prison_service

    summary = [
      {
        key: { text: t("request_form.prison_location.#{@information_request.subject}") },
        value: { text: @information_request.currently_in_prison.capitalize },
        actions: { text: "Change", href: back_request_path("prison-location"), visually_hidden_text: t("helpers.label.request_form.current_prison_name.#{@information_request.subject}") },
      },
    ]

    if @information_request.currently_in_prison == "yes"
      summary.push(
        {
          key: { text: t("helpers.label.request_form.current_prison_name.#{@information_request.subject}") },
          value: { text: @information_request.current_prison_name },
          actions: { text: "Change", href: back_request_path("prison-location"), visually_hidden_text: t("helpers.label.request_form.current_prison_name.#{@information_request.subject}") },
        },
      )
    else
      summary.push(
        {
          key: { text: t("helpers.label.request_form.recent_prison_name.#{@information_request.subject}") },
          value: { text: @information_request.recent_prison_name },
          actions: { text: "Change", href: back_request_path("prison-location"), visually_hidden_text: t("helpers.label.request_form.recent_prison_name.#{@information_request.subject}") },
        },
      )
    end

    summary.push(
      {
        key: { text: t("request_form.prison_number.#{@information_request.subject}") },
        value: { text: @information_request.prison_number },
        actions: { text: "Change", href: back_request_path("prison-number"), visually_hidden_text: t("request_form.prison_number.#{@information_request.subject}") },
      },
      {
        key: { text: t("request_form.prison_information") },
        value: { text: @information_request.prison_information },
        actions: { text: "Change", href: back_request_path("prison-information"), visually_hidden_text: t("request_form.prison_information") },
      },
    )

    if @information_request.prison_other_data.present?
      summary.push(
        {
          key: { text: t("helpers.label.request_form.prison_other_data_text") },
          value: { text: @information_request.prison_other_data_text },
          actions: { text: "Change", href: back_request_path("prison-information"), visually_hidden_text: t("helpers.label.request_form.prison_other_data_text") },
        }
      )
    end


    summary.push(
      {
        key: { text: t("helpers.legend.request_form.prison_date_from") },
        value: { text: @information_request.prison_date_from },
        actions: { text: "Change", href: back_request_path("prison-dates"), visually_hidden_text: t("helpers.legend.request_form.prison_date_from") },
      },
      {
        key: { text: t("helpers.legend.request_form.prison_date_to") },
        value: { text: @information_request.prison_date_to },
        actions: { text: "Change", href: back_request_path("prison-dates"), visually_hidden_text: t("helpers.legend.request_form.prison_date_to") },
      },
    )

    summary
  end

  def probation_summary
    return unless @information_request.probation_service

    summary = [
      {
        key: { text: t("request_form.probation_location.#{@information_request.subject}") },
        value: { text: @information_request.probation_office },
        actions: { text: "Change", href: back_request_path("probation-location"), visually_hidden_text: t("request_form.probation_location.#{@information_request.subject}") },
      },
      {
        key: { text: t("request_form.probation_information") },
        value: { text: @information_request.probation_information },
        actions: { text: "Change", href: back_request_path("probation-information"), visually_hidden_text: t("request_form.probation_information") },
      },
    ]

    if @information_request.probation_other_data.present?
      summary.push(
        {
          key: { text: t("helpers.label.request_form.probation_other_data_text") },
          value: { text: @information_request.probation_other_data_text },
          actions: { text: "Change", href: back_request_path("probation-information"), visually_hidden_text: t("helpers.label.request_form.probation_other_data_text") },
        }
      )
    end

    summary.push(
      {
        key: { text: t("helpers.legend.request_form.probation_date_from") },
        value: { text: @information_request.probation_date_from },
        actions: { text: "Change", href: back_request_path("probation-dates"), visually_hidden_text: t("helpers.legend.request_form.probation_date_from") },
      },
      {
        key: { text: t("helpers.legend.request_form.probation_date_to") },
        value: { text: @information_request.probation_date_to },
        actions: { text: "Change", href: back_request_path("probation-dates"), visually_hidden_text: t("helpers.legend.request_form.probation_date_to") },
      },
    )

    summary
  end
end
