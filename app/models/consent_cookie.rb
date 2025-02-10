module ConsentCookie
  COOKIE_NAME = Rails.configuration.x.cookies_consent_name
  EXPIRATION = Rails.configuration.x.cookies_consent_expiration

  ACCEPT = "accept".freeze
  REJECT = "reject".freeze
end
