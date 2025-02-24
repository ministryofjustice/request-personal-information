module ApplicationHelper
  def title(page_title)
    content_for :page_title, [page_title.presence&.strip, service_name].compact.join(" - ")
  end

  def service_name
    t("service.name")
  end
end
