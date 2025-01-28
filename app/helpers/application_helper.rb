module ApplicationHelper
  def govuk_label(text:, tag:, size:)
    content_tag(tag, text, class: "govuk-label govuk-label--#{size}")
  end
end
