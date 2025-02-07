module AnalyticsHelper
  def analytics_consent_cookie
    cookies[Rails.configuration.x.cookies_consent_name]
  end
end
