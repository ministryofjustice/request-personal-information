# spec/features/cookie_settings_spec.rb
require "rails_helper"

RSpec.feature "CookieSettings", type: :feature do
  scenario "User accepts analytics cookies" do
    visit cookies_path

    choose "Yes"
    click_button "Save cookie settings"

    expect(page).to have_content("You’ve accepted analytics cookies.")
    expect(page.driver.browser.rack_mock_session.cookie_jar["rpi_cookies_consent"]).to eq("accept")
  end

  scenario "User rejects analytics cookies" do
    visit cookies_path

    choose "No"
    click_button "Save cookie settings"

    expect(page).to have_content("You’ve rejected analytics cookies.")
    expect(page.driver.browser.rack_mock_session.cookie_jar["rpi_cookies_consent"]).to eq("reject")
  end
end
