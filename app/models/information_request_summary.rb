class InformationRequestSummary
  include Rails.application.routes.url_helpers

  def initialize(information_request)
    @information_request = information_request
  end

  def subject
    summary = [
      {
        key: { text: I18n.t("helpers.label.request_form.full_name") },
        value: { text: @information_request.full_name },
        actions: { text: "Change", href: with_query_string("/subject-name"), visually_hidden_text: I18n.t("helpers.label.request_form.full_name") },
      },
      {
        key: { text: I18n.t("helpers.label.request_form.other_names.#{@information_request.subject}") },
        value: { text: @information_request.other_names },
        actions: { text: "Change", href: with_query_string("/subject-name"), visually_hidden_text: I18n.t("helpers.label.request_form.other_names.#{@information_request.subject}") },
      },
      {
        key: { text: I18n.t("request_form.subject_date_of_birth.#{@information_request.subject}") },
        value: { text: format_date(@information_request.date_of_birth) },
        actions: { text: "Change", href: with_query_string("/subject-date-of-birth"), visually_hidden_text: I18n.t("helpers.label.request_form.date_of_birth") },
      },
    ]

    unless @information_request.for_self?
      summary.push(
        {
          key: { text: I18n.t("request_form.subject_relationship") },
          value: { text: RequestForm::SubjectRelationship::OPTIONS[@information_request.relationship.to_sym] },
          actions: { text: "Change", href: with_query_string("/subject-relationship"), visually_hidden_text: I18n.t("request_form.subject_relationship") },
        },
      )
    end

    summary
  end

  def requester
    return if @information_request.for_self?

    if @information_request.by_solicitor?
      [
        {
          key: { text: I18n.t("helpers.label.request_form.organisation_name") },
          value: { text: @information_request.organisation_name },
          actions: { text: "Change", href: with_query_string("/solicitor-details"), visually_hidden_text: I18n.t("helpers.label.request_form.organisation_name") },
        },
        {
          key: { text: I18n.t("helpers.label.request_form.requester_name") },
          value: { text: @information_request.requester_name },
          actions: { text: "Change", href: with_query_string("/solicitor-details"), visually_hidden_text: I18n.t("helpers.label.request_form.requester_name") },
        },
      ]
    else
      [
        {
          key: { text: "Your full name" },
          value: { text: @information_request.requester_name },
          actions: { text: "Change", href: with_query_string("/requester-details"), visually_hidden_text: I18n.t("helpers.label.request_form.requester_name") },
        },
      ]
    end
  end

  def requester_id
    return if @information_request.for_self?

    summary = []

    unless @information_request.by_solicitor?
      summary.push(
        {
          key: { text: I18n.t("helpers.label.request_form.requester_photo") },
          value: { text: @information_request.requester_photo.to_s },
          actions: { text: "Change", href: with_query_string("/requester-id"), visually_hidden_text: I18n.t("helpers.label.request_form.requester_photo") },
        },
        {
          key: { text: I18n.t("helpers.label.request_form.requester_proof_of_address") },
          value: { text: @information_request.requester_proof_of_address.to_s },
          actions: { text: "Change", href: with_query_string("/requester-address"), visually_hidden_text: I18n.t("helpers.label.request_form.requester_proof_of_address") },
        },
      )
    end

    summary.push(
      {
        key: { text: I18n.t("request_form.letter_of_consent") },
        value: { text: @information_request.letter_of_consent.to_s },
        actions: { text: "Change", href: with_query_string("/letter-of-consent"), visually_hidden_text: I18n.t("request_form.letter_of_consent") },
      },
    )

    summary
  end

  def subject_id
    return if @information_request.by_solicitor?

    [
      {
        key: { text: I18n.t("helpers.label.request_form.subject_photo") },
        value: { text: @information_request.subject_photo.to_s },
        actions: { text: "Change", href: with_query_string("/subject-id"), visually_hidden_text: I18n.t("helpers.label.request_form.subject_photo") },
      },
      {
        key: { text: I18n.t("helpers.label.request_form.subject_proof_of_address") },
        value: { text: @information_request.subject_proof_of_address.to_s },
        actions: { text: "Change", href: with_query_string("/subject-address"), visually_hidden_text: I18n.t("helpers.label.request_form.subject_proof_of_address") },
      },
    ]
  end

  def information
    [{
      key: { text: I18n.t("helpers.hint.request_form.moj") },
      value: { text: format_list(@information_request.information_required) },
      actions: { text: "Change", href: with_query_string("/moj"), visually_hidden_text: I18n.t("helpers.hint.request_form.moj") },
    }]
  end

  def prison
    return unless @information_request.prison_service

    summary = []

    if @information_request.for_self?
      summary.push(
        {
          key: { text: I18n.t("request_form.prison_location.#{@information_request.subject}") },
          value: { text: @information_request.recent_prison_name },
          actions: { text: "Change", href: with_query_string("/prison-location"), visually_hidden_text: I18n.t("request_form.prison_location.#{@information_request.subject}") },
        },
      )
    end

    unless @information_request.for_self?
      summary.push(
        {
          key: { text: I18n.t("request_form.prison_location.#{@information_request.subject}") },
          value: { text: @information_request.currently_in_prison.capitalize },
          actions: { text: "Change", href: with_query_string("/prison-location"), visually_hidden_text: I18n.t("request_form.prison_location.#{@information_request.subject}") },
        },
      )

      if @information_request.currently_in_prison == "yes"
        summary.push(
          {
            key: { text: I18n.t("helpers.label.request_form.current_prison_name") },
            value: { text: @information_request.current_prison_name },
            actions: { text: "Change", href: with_query_string("/prison-location"), visually_hidden_text: I18n.t("helpers.label.request_form.current_prison_name") },
          },
        )
      else
        summary.push(
          {
            key: { text: I18n.t("helpers.label.request_form.recent_prison_name") },
            value: { text: @information_request.recent_prison_name },
            actions: { text: "Change", href: with_query_string("/prison-location"), visually_hidden_text: I18n.t("helpers.label.request_form.recent_prison_name") },
          },
        )
      end
    end

    summary.push(
      {
        key: { text: I18n.t("request_form.prison_number.#{@information_request.subject}") },
        value: { text: @information_request.prison_number },
        actions: { text: "Change", href: with_query_string("/prison-number"), visually_hidden_text: I18n.t("request_form.prison_number.#{@information_request.subject}") },
      },
      {
        key: { text: I18n.t("request_form.prison_information") },
        value: { text: format_list(@information_request.prison_information) },
        actions: { text: "Change", href: with_query_string("/prison-information"), visually_hidden_text: I18n.t("request_form.prison_information") },
      },
    )

    if @information_request.prison_other_data.present?
      summary.push(
        {
          key: { text: I18n.t("helpers.label.request_form.prison_other_data_text") },
          value: { text: @information_request.prison_other_data_text },
          actions: { text: "Change", href: with_query_string("/prison-information"), visually_hidden_text: I18n.t("helpers.label.request_form.prison_other_data_text") },
        },
      )
    end

    summary.push(
      {
        key: { text: I18n.t("helpers.legend.request_form.form_prison_date_from") },
        value: { text: format_date(@information_request.prison_date_from) },
        actions: { text: "Change", href: with_query_string("/prison-dates"), visually_hidden_text: I18n.t("helpers.legend.request_form.form_prison_date_from") },
      },
      {
        key: { text: I18n.t("helpers.legend.request_form.form_prison_date_to") },
        value: { text: format_date(@information_request.prison_date_to) },
        actions: { text: "Change", href: with_query_string("/prison-dates"), visually_hidden_text: I18n.t("helpers.legend.request_form.form_prison_date_to") },
      },
    )

    summary
  end

  def probation
    return unless @information_request.probation_service

    summary = [
      {
        key: { text: I18n.t("request_form.probation_location.#{@information_request.subject}") },
        value: { text: @information_request.probation_office },
        actions: { text: "Change", href: with_query_string("/probation-location"), visually_hidden_text: I18n.t("request_form.probation_location.#{@information_request.subject}") },
      },
      {
        key: { text: I18n.t("request_form.probation_information") },
        value: { text: format_list(@information_request.probation_information) },
        actions: { text: "Change", href: with_query_string("/probation-information"), visually_hidden_text: I18n.t("request_form.probation_information") },
      },
    ]

    if @information_request.probation_other_data.present?
      summary.push(
        {
          key: { text: I18n.t("helpers.label.request_form.probation_other_data_text") },
          value: { text: @information_request.probation_other_data_text },
          actions: { text: "Change", href: with_query_string("/probation-information"), visually_hidden_text: I18n.t("helpers.label.request_form.probation_other_data_text") },
        },
      )
    end

    summary.push(
      {
        key: { text: I18n.t("helpers.legend.request_form.form_probation_date_from") },
        value: { text: format_date(@information_request.probation_date_from) },
        actions: { text: "Change", href: with_query_string("/probation-dates"), visually_hidden_text: I18n.t("helpers.legend.request_form.form_probation_date_from") },
      },
      {
        key: { text: I18n.t("helpers.legend.request_form.form_probation_date_to") },
        value: { text: format_date(@information_request.probation_date_to) },
        actions: { text: "Change", href: with_query_string("/probation-dates"), visually_hidden_text: I18n.t("helpers.legend.request_form.form_probation_date_to") },
      },
    )

    summary
  end

  def laa
    return unless @information_request.laa

    [
      {
        key: { text: I18n.t("request_form.laa") },
        value: { text: @information_request.laa_text },
        actions: { text: "Change", href: with_query_string("/laa"), visually_hidden_text: I18n.t("request_form.laa") },
      },
      {
        key: { text: I18n.t("helpers.legend.request_form.form_laa_date_from") },
        value: { text: format_date(@information_request.laa_date_from) },
        actions: { text: "Change", href: with_query_string("/laa-dates"), visually_hidden_text: I18n.t("helpers.legend.request_form.form_laa_date_from") },
      },
      {
        key: { text: I18n.t("helpers.legend.request_form.form_laa_date_to") },
        value: { text: format_date(@information_request.laa_date_to) },
        actions: { text: "Change", href: with_query_string("/laa-dates"), visually_hidden_text: I18n.t("helpers.legend.request_form.form_laa_date_to") },
      },
    ]
  end

  def opg
    return unless @information_request.opg

    [
      {
        key: { text: I18n.t("request_form.opg") },
        value: { text: @information_request.opg_text },
        actions: { text: "Change", href: with_query_string("/opg"), visually_hidden_text: I18n.t("request_form.opg") },
      },
      {
        key: { text: I18n.t("helpers.legend.request_form.form_opg_date_from") },
        value: { text: format_date(@information_request.opg_date_from) },
        actions: { text: "Change", href: with_query_string("/opg-dates"), visually_hidden_text: I18n.t("helpers.legend.request_form.form_opg_date_from") },
      },
      {
        key: { text: I18n.t("helpers.legend.request_form.form_opg_date_to") },
        value: { text: format_date(@information_request.opg_date_to) },
        actions: { text: "Change", href: with_query_string("/opg-dates"), visually_hidden_text: I18n.t("helpers.legend.request_form.form_opg_date_to") },
      },
    ]
  end

  def moj_other
    return unless @information_request.moj_other

    [

      {
        key: { text: I18n.t("request_form.other_where") },
        value: { text: @information_request.moj_other_where },
        actions: { text: "Change", href: with_query_string("/other-where"), visually_hidden_text: I18n.t("request_form.other_where") },
      },
      {
        key: { text: I18n.t("request_form.other") },
        value: { text: @information_request.moj_other_text },
        actions: { text: "Change", href: with_query_string("/other"), visually_hidden_text: I18n.t("request_form.other") },
      },
      {
        key: { text: I18n.t("helpers.legend.request_form.form_moj_other_date_from") },
        value: { text: format_date(@information_request.moj_other_date_from) },
        actions: { text: "Change", href: with_query_string("/other-dates"), visually_hidden_text: I18n.t("helpers.legend.request_form.form_moj_other_date_from") },
      },
      {
        key: { text: I18n.t("helpers.legend.request_form.form_moj_other_date_to") },
        value: { text: format_date(@information_request.moj_other_date_to) },
        actions: { text: "Change", href: with_query_string("/other-dates"), visually_hidden_text: I18n.t("helpers.legend.request_form.form_moj_other_date_to") },
      },
    ]
  end

  def contact
    summary = [
      {
        key: { text: I18n.t("helpers.label.request_form.contact_address") },
        value: { text: @information_request.contact_address },
        actions: { text: "Change", href: with_query_string("/contact-address"), visually_hidden_text: I18n.t("helpers.label.request_form.contact_address") },
      },
      {
        key: { text: I18n.t("helpers.label.request_form.contact_email") },
        value: { text: @information_request.contact_email },
        actions: { text: "Change", href: with_query_string("/contact-email"), visually_hidden_text: I18n.t("helpers.label.request_form.contact_email") },
      },
      {
        key: { text: I18n.t("request_form.upcoming") },
        value: { text: @information_request.upcoming_court_case.capitalize },
        actions: { text: "Change", href: with_query_string("/upcoming"), visually_hidden_text: I18n.t("request_form.upcoming") },
      },
    ]

    if @information_request.upcoming_court_case == "yes"
      summary.push(
        {
          key: { text: I18n.t("helpers.label.request_form.upcoming_court_case_text") },
          value: { text: @information_request.upcoming_court_case_text },
          actions: { text: "Change", href: with_query_string("/upcoming"), visually_hidden_text: I18n.t("helpers.label.request_form.upcoming_court_case_text") },
        },
      )
    end

    summary
  end

private

  def format_list(list)
    list.sub(", ", "<br>").html_safe
  end

  def format_date(date)
    date&.to_fs(:day_month_and_year)
  end

  def with_query_string(path)
    "#{path}?return_to=check-answers"
  end
end
