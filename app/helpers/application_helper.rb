module ApplicationHelper
  def service_name
    t("service.name")
  end

  def title(page_title)
    content_for(:title) do
      page_title.present? ? "#{page_title} - #{service_name}" : service_name
    end
  end
end
