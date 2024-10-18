require "rails_helper"

RSpec.describe RequestForm::OtherWhere, type: :model do
  it_behaves_like "question when requesting other data"
  it_behaves_like "question with standard saveable attributes"

  it { is_expected.to validate_presence_of(:moj_other_where) }
end
