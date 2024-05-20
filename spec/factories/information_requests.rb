FactoryBot.define do
  factory :information_request do
    subject { "self" }

    trait :for_self do
      subject { "self" }
    end

    trait :for_other do
      subject { "other" }
    end

    trait :by_solicitor do
      relationship { "legal_representative" }
    end

    trait :by_friend do
      relationship { "other" }
    end

    trait :with_consent do
      letter_of_consent { Rack::Test::UploadedFile.new("spec/fixtures/files/file.jpg", "image/jpg") }
    end

    trait :with_requester_id do
      requester_photo { Rack::Test::UploadedFile.new("spec/fixtures/files/file.jpg", "image/jpg") }
      requester_proof_of_address { Rack::Test::UploadedFile.new("spec/fixtures/files/file.jpg", "image/jpg") }
    end

    trait :with_subject_id do
      subject_photo { Rack::Test::UploadedFile.new("spec/fixtures/files/file.jpg", "image/jpg") }
      subject_proof_of_address { Rack::Test::UploadedFile.new("spec/fixtures/files/file.jpg", "image/jpg") }
    end

    trait :prison_service do
      prison_service { true }
    end

    trait :probation_service do
      probation_service { true }
    end

    factory :information_request_for_self, traits: %i[for_self]
    factory :information_request_for_other, traits: %i[for_other]
    factory :information_request_by_solicitor, traits: %i[for_other by_solicitor]
    factory :information_request_by_friend, traits: %i[for_other by_friend]
    factory :information_request_with_consent, traits: %i[for_other with_consent]
    factory :information_request_with_requester_id, traits: %i[for_other with_requester_id]
    factory :information_request_with_subject_id, traits: %i[for_other with_subject_id]
    factory :information_request_for_prison_service, traits: %i[for_self prison_service]
    factory :information_request_for_probation_service, traits: %i[for_self probation_service]
  end
end
