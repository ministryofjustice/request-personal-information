module ApplicationHelper
  def service_name
    t("service.name")
  end

  def title(page_title)
    content_for(:title) { page_title }
  end
end
