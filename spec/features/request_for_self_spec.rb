require "rails_helper"

RSpec.feature "Request for self", type: :feature do
  scenario "User makes end to end request" do
    visit "/"

    # Start page
    click_link "Start now"

    # Subject
    choose "My own"
    click_button "Continue"

    # Your details
    fill_in("Full name", with: "John")
    click_button "Continue"

    # Date of birth
    fill_in("Day", with: "1")
    fill_in("Month", with: "1")
    fill_in("Year", with: "2000")
    click_button "Continue"

    # Upload ID
    attach_file("request-form-subject-photo-field", "spec/fixtures/files/file.jpg")
    click_button "Continue"

    # Upload address
    attach_file("request-form-subject-proof-of-address-field", "spec/fixtures/files/file.jpg")
    click_button "Continue"

    # Confirm upload
    choose "Yes, add these uploads"
    click_button "Continue"

    # Information from where
    check "Prison service"
    click_button "Continue"

    # Prison name
    fill_in("request-form-recent-prison-name-field", with: "HMP Brixton")
    click_button "Continue"

    # Prison number
    click_button "Continue"

    # Types of information
    check "NOMIS Records"
    click_button "Continue"

    # Date range
    click_button "Continue"

    # Requester address
    fill_in("Your address", with: "1 High Street")
    click_button "Continue"

    # Your email
    click_button "Continue"

    # Upcoming case?
    choose "No"
    click_button "Continue"

    # Check answers
    expect(page).to have_text("Check your answers")
    click_button "Accept and send request"

    # Form sent
    expect(page).to have_text("Request sent")
  end
end
