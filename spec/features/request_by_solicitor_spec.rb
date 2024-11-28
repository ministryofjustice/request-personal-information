require "rails_helper"

RSpec.feature "Request by solicitor", type: :feature do
  scenario "User makes end to end request" do
    visit "/"

    # Start page
    click_link "Start now"

    # Subject
    choose "Someone else's"
    click_button "Continue"

    # Your details
    fill_in("Full name", with: "John")
    click_button "Continue"

    # Date of birth
    fill_in("Day", with: "1")
    fill_in("Month", with: "1")
    fill_in("Year", with: "2000")
    click_button "Continue"

    # Relationship
    choose "Legal representative"
    click_button "Continue"

    # Your details
    fill_in("Name of your organisation", with: "Solicitor Name")
    click_button "Continue"

    # Letter of Consent
    attach_file("request-form-letter-of-consent-field", "spec/fixtures/files/file.jpg")
    click_button "Continue"

    # Contine
    click_button "Continue"

    # Information from where
    check "Probation service"
    click_button "Continue"

    # Probation office
    fill_in("request-form-probation-office-field", with: "Leicester")
    click_button "Continue"

    # Types of information
    check "Something else"
    fill_in("What other information do you want?", with: "more info")
    click_button "Continue"

    # Date range
    click_button "Continue"

    # Requester address
    fill_in("Your address", with: "1 High Street")
    click_button "Continue"

    # Your email
    click_button "Continue"

    # Upcoming case?
    choose "Yes"
    fill_in("Can you provide more details?", with: "Info about hearing")
    click_button "Continue"

    # Check answers
    expect(page).to have_text("Check your answers")
    click_button "Accept and send request"

    # Form sent
    expect(page).to have_text("Request sent")
  end
end
