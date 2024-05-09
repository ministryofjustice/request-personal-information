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

    factory :information_request_for_self, traits: %i[for_self]
    factory :information_request_for_other, traits: %i[for_other]
    factory :information_request_by_solicitor, traits: %i[for_other by_solicitor]
    factory :information_request_by_friend, traits: %i[for_other by_friend]
    factory :information_request_with_consent, traits: %i[for_other with_consent]
  end
end
