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
