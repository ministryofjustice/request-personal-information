require "rails_helper"

RSpec.feature "CookieBanner", :js, type: :feature do
  before do
    visit "/"
  end

  scenario "User sees the cookie banner on the homepage" do
    expect(page).to have_content("We use some essential cookies to make this service work.")
  end

  scenario "User accepts analytics cookies" do
    expect(page).to have_content("We use some essential cookies to make this service work.", wait: 10 )
    click_button "Accept analytics cookies"
    expect(page).not_to have_content("We use some essential cookies to make this service work.", wait: 10)
    expect(page).to have_content("You’ve accepted analytics cookies.", wait: 10 )
  end

  scenario "User rejects analytics cookies" do
    expect(page).to have_content("We use some essential cookies to make this service work.", wait: 10 )
    click_button "Reject analytics cookies"
    expect(page).not_to have_content("We use some essential cookies to make this service work.", wait: 10 )
    expect(page).to have_content("You’ve rejected analytics cookies. You can change your cookie settings at any time.", wait: 10 )
  end
end
