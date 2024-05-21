require "rails_helper"

RSpec.describe RequestForm::Opg, type: :model do
  it_behaves_like "question when requesting opg data"
  it_behaves_like "question with standard saveable attributes"

  it { is_expected.to validate_presence_of(:opg_text) }
end
