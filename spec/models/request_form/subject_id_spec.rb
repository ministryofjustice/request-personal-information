require "rails_helper"

RSpec.describe RequestForm::SubjectId, type: :model do
  it_behaves_like "question when requester is not a solicitor"
  it_behaves_like "file upload with max filesize validation", :subject_photo
  it_behaves_like "file upload with max filesize validation", :subject_proof_of_address
end
