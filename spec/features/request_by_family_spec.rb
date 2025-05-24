require "rails_helper"

RSpec.feature "Request by family", type: :feature do
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
    choose "Relative, friend or something else"
    click_button "Continue"

    # Your details
    fill_in("Your full name", with: "Mary")
    click_button "Continue"

    # Upload your ID
    attach_file("request-form-requester-photo-field", "spec/fixtures/files/file.jpg")
    click_button "Continue"

    # Upload your address ID
    attach_file("request-form-requester-proof-of-address-field", "spec/fixtures/files/file.jpg")
    click_button "Continue"

    # Letter of Consent
    attach_file("request-form-letter-of-consent-field", "spec/fixtures/files/file.jpg")
    click_button "Continue"

    # Contine
    click_button "Continue"

    # Upload their photo ID
    attach_file("request-form-subject-photo-field", "spec/fixtures/files/file.jpg")
    click_button "Continue"

    # Upload their address ID
    attach_file("request-form-subject-proof-of-address-field", "spec/fixtures/files/file.jpg")
    click_button "Continue"

    # Continue
    click_button "Continue"

    # Information from where
    check "Somewhere else in the Ministry of Justice"
    click_button "Continue"

    # Other where
    fill_in("request-form-moj-other-where-field", with: "location of information")
    click_button "Continue"

    # Other information
    fill_in("request-form-moj-other-text-field", with: "information required")
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

  describe "User uploads invalid files and cannot progress" do
    before do
      start_application
      fill_in_request_type_and_initial_personal_details(type: "Relative, friend or something else")
    end

    scenario "when requester photo id" do
      # Upload ID
      attach_file("request-form-requester-photo-field", "spec/fixtures/files/invalid_image.txt")
      click_button "Continue"
      expect(page).to have_text("There is a problem")
      expect(page).to have_text("Upload your photo ID")
      click_button "Continue"
      expect(page).not_to have_text("Upload your proof of address")
      expect(page).to have_text("There is a problem")
      expect(page).to have_text("Upload your photo ID")
    end

    scenario "when requester address" do
      # Upload ID
      attach_file("request-form-requester-photo-field", "spec/fixtures/files/file.jpg")
      click_button "Continue"
      expect(page).to have_text("Upload your proof of address")
      # Upload address
      attach_file("request-form-requester-proof-of-address-field", "spec/fixtures/files/invalid_image.txt")
      click_button "Continue"
      expect(page).to have_text("There is a problem")
      expect(page).to have_text("Upload your proof of address")
      click_button "Continue"
      expect(page).to have_text("There is a problem")
      expect(page).to have_text("Upload your proof of address")
    end

    scenario "when requester letter of consent" do
      # Upload ID
      attach_file("request-form-requester-photo-field", "spec/fixtures/files/file.jpg")
      click_button "Continue"
      expect(page).to have_text("Upload your proof of address")
      # Upload address
      attach_file("request-form-requester-proof-of-address-field", "spec/fixtures/files/file.jpg")
      click_button "Continue"
      expect(page).to have_text("Upload a letter of consent")
      # Letter of Consent
      attach_file("request-form-letter-of-consent-field", "spec/fixtures/files/invalid_image.txt")
      click_button "Continue"
      expect(page).to have_text("There is a problem")
      expect(page).to have_text("Upload a letter of consent")
      click_button "Continue"
      expect(page).to have_text("There is a problem")
      expect(page).to have_text("Upload a letter of consent")
    end
  end
end
