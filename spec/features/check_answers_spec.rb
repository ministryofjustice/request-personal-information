require "rails_helper"

RSpec.feature "Edit answers", type: :feature do
  scenario "User changes upload" do
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

    # Change upload
    first("tr").click_link "Change"

    # Upload new ID
    attach_file("request-form-subject-photo-field", "spec/fixtures/files/file.jpg")
    click_button "Continue"

    # Back to check page
    expect(page).to have_text("Check your uploads")
  end

  scenario "User adds all data and then edits answers" do
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

    # Contine
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
    check "NOMIS records"
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

    # Change name
    within all(".govuk-summary-list__row")[1] do
      click_link "Change"
    end
    expect(page).to have_text("What is your name?")
    fill_in("Full name", with: "Michael")
    click_button "Continue"

    # See changed name
    expect(page).to have_text("Check your answers")
    expect(page).to have_text("Michael")
  end

  scenario "User adds all data and then edits answers that requires additional information" do
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

    # Contine
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
    check "NOMIS records"
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

    # Change who is requesting
    within all(".govuk-summary-list__row")[0] do
      click_link "Change"
    end
    expect(page).to have_text("Are you requesting your own information or someone else's?")
    choose "Someone else's"
    click_button "Continue"

    # Goes to next form, not check answers
    expect(page).to have_text("What is their name?")
  end
end
