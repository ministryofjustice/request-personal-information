require "rails_helper"

RSpec.describe RequestForm::Laa, type: :model do
  it_behaves_like "question when requesting laa data"
  it_behaves_like "question with standard saveable attributes"

  it { is_expected.to validate_presence_of(:laa_text) }
end
