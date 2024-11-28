require "rails_helper"

RSpec.describe RequestForm::LetterOfConsentCheck, type: :model do
  it_behaves_like "question for solicitor"
  it_behaves_like "question with standard saveable attributes"
end
