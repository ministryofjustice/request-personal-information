def start_application
  visit "/"
  click_link "Start now"
end

def fill_in_request_type_and_initial_personal_details(type: "My own")
  case type
  when "My own"
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
  when "Relative, friend or something else"
    non_self_request_page_flow

    # Relationship
    choose type
    click_button "Continue"

    # Your details
    fill_in("Your full name", with: "Mary")
    click_button "Continue"
  when "Legal representative"
    non_self_request_page_flow

    # Relationship
    choose type
    click_button "Continue"

    # Your details
    fill_in("Name of your organisation", with: "Solicitor Name")
    click_button "Continue"
  else
    raise "Unknown type: #{type}"
  end
end

def non_self_request_page_flow
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
end
