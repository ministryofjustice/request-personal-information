require "rails_helper"

RSpec.feature "CookieBanner", :js, type: :feature do
  before do
    visit root_path
  end

  scenario "User sees the cookie banner" do
    expect(page).to have_content("We use some essential cookies to make this service work.")
  end

  scenario "User accepts analytics cookies" do
    expect(page).to have_content("We use some essential cookies to make this service work.")
    click_button "Accept analytics cookies"
    expect(page).not_to have_content("We use some essential cookies to make this service work.")
  end

  scenario "User rejects analytics cookies" do
    expect(page).to have_content("We use some essential cookies to make this service work.")
    click_button "Reject analytics cookies"
    expect(page).not_to have_content("We use some essential cookies to make this service work.")
  end
end
