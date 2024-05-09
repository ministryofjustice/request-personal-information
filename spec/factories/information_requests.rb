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

    factory :information_request_for_self, traits: [:for_self]
    factory :information_request_for_other, traits: [:for_other]
    factory :information_request_by_solicitor, traits: [:for_other, :by_solicitor]
    factory :information_request_by_friend, traits: [:for_other, :by_friend]
  end
end
