class PagesController < ApplicationController
  include AnalyticsHelper

  def accessibility; end

  def cookie_consent
    @consent = analytics_consent_cookie || ConsentCookie::REJECT
  end

  def homepage; end

  def privacy; end
end
