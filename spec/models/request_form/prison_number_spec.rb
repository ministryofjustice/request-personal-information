require "rails_helper"

RSpec.describe RequestForm::PrisonNumber, type: :model do
  it_behaves_like "question when requesting prison data"
  it_behaves_like "validated attribute with custom message", :prison_number, "ABC12345"
  it_behaves_like "question with standard saveable attributes"
end
