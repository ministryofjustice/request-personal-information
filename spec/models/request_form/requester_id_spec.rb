require "rails_helper"

RSpec.describe RequestForm::RequesterId, type: :model do
  it_behaves_like "question for friend or family of subject"
  it_behaves_like "file upload", :requester_photo
  it_behaves_like "file upload", :requester_proof_of_address
end
