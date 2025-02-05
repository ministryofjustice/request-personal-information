# spec/features/cookie_banner_spec.rb
require 'rails_helper'

RSpec.feature "CookieBanner", type: :feature,  js: true do
  scenario "User sees the cookie banner" do
    visit root_path
    expect(page).to have_content("We use some essential cookies to make this service work.")
  end

  scenario "User accepts analytics cookies" do
    visit root_path
    expect(page).to have_content("We use some essential cookies to make this service work.")
    click_button "Accept analytics cookies"
    expect(page).not_to have_content("We use some essential cookies to make this service work.")
  end

  scenario "User rejects analytics cookies" do
    visit root_path
    expect(page).to have_content("We use some essential cookies to make this service work.")
    click_button "Reject analytics cookies"
    expect(page).not_to have_content("We use some essential cookies to make this service work.")
  end

  scenario "User does not accept or reject analytics cookies" do
    visit root_path
    expect(page).to have_content("We use some essential cookies to make this service work.")
  end
end
