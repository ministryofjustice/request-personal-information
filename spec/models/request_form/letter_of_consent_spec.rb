require "rails_helper"

RSpec.describe RequestForm::LetterOfConsent, type: :model do
  it_behaves_like "question when requester is not the subject"
  it_behaves_like "file upload", :letter_of_consent
end
