require "rails_helper"

RSpec.feature "CookieBanner", type: :feature do
  before do
    visit "/"
  end

  scenario "User sees the cookie banner on the homepage" do
    expect(page).to have_content("We use some essential cookies to make this service work.")
  end

  scenario "User accepts analytics cookies" do
    expect(page).to have_content("We use some essential cookies to make this service work.")
    click_link "Accept analytics cookies"
    expect(page).not_to have_content("We use some essential cookies to make this service work.")
    expect(page).to have_content("You've accepted analytics cookies.")
  end

  scenario "User rejects analytics cookies" do
    expect(page).to have_content("We use some essential cookies to make this service work.")
    click_link "Reject analytics cookies"
    expect(page).not_to have_content("We use some essential cookies to make this service work.")
    expect(page).to have_content("You've rejected analytics cookies. You can change your cookie settings at any time.")
  end
end

RSpec.feature "Cookies page", type: :feature do
  before do
    visit "/cookies"
  end

  scenario "User does not want to accept analytics cookies" do
    choose "No"
    click_button "Save cookie settings"
    expect(page).not_to have_content("We use some essential cookies to make this service work.")
    expect(page).to have_content("You've rejected analytics cookies. You can change your cookie settings at any time.")
  end

  scenario "User wants to accept analytics cookies" do
    choose "Yes"
    click_button "Save cookie settings"
    expect(page).not_to have_content("We use some essential cookies to make this service work.")
    expect(page).to have_content("You've accepted analytics cookies.")
  end
end
