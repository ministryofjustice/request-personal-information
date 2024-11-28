require "rails_helper"

RSpec.describe RequestForm::RequesterIdCheck, type: :model do
  it_behaves_like "question for friend or family of subject"
  it_behaves_like "question with standard saveable attributes"
end
