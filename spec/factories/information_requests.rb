FactoryBot.define do
  factory :information_request do
    subject { "self" }
    full_name { "Cristian Romero" }
    other_names { "Cuti" }
    date_of_birth { Date.new(1998, 4, 27) }

    trait :for_self do
      subject { "self" }
    end

    trait :for_other do
      subject { "other" }
      relationship { "other" }
    end

    trait :by_solicitor do
      relationship { "legal_representative" }
      organisation_name { "Van de Ven Solicitors" }
      requester_name { "Micky" }
    end

    trait :by_friend do
      relationship { "other" }
      requester_name { "Radu" }
    end

    trait :with_consent do
      letter_of_consent { Rack::Test::UploadedFile.new("spec/fixtures/files/file.jpg", "image/jpg") }
    end

    trait :with_requester_id do
      requester_photo { Rack::Test::UploadedFile.new("spec/fixtures/files/file.jpg", "image/jpg") }
    end

    trait :with_requester_address do
      requester_proof_of_address { Rack::Test::UploadedFile.new("spec/fixtures/files/file.jpg", "image/jpg") }
    end

    trait :with_subject_id do
      subject_photo { Rack::Test::UploadedFile.new("spec/fixtures/files/file.jpg", "image/jpg") }
      subject_proof_of_address { Rack::Test::UploadedFile.new("spec/fixtures/files/file.jpg", "image/jpg") }
    end

    trait :prison_service do
      prison_service { true }
      currently_in_prison { "no" }
      recent_prison_name { "HMP Fosse Way" }
      prison_number { "ABC123" }
      prison_nomis_records { true }
      prison_date_from { Date.new(2010, 3, 10) }
      prison_date_to { Date.new(2012, 5, 20) }
    end

    trait :probation_service do
      probation_service { true }
      probation_office { "Leicester" }
      probation_ndelius { true }
      probation_date_from { Date.new(2014, 1, 12) }
      probation_date_to { Date.new(2020, 11, 2) }
    end

    trait :laa do
      laa { true }
      laa_text { "laa details" }
      laa_date_from { Date.new(2015, 1, 20) }
      laa_date_to { Date.new(2016, 3, 1) }
    end

    trait :opg do
      opg { true }
      opg_text { "opg details" }
      opg_date_from { Date.new(2017, 7, 19) }
      opg_date_to { Date.new(2019, 3, 2) }
    end

    trait :moj_other do
      moj_other { true }
      moj_other_where { "other location" }
      moj_other_text { "other details" }
      moj_other_date_from { Date.new(1980, 1, 1) }
      moj_other_date_to { Date.new(1990, 12, 31) }
    end

    trait :with_contact do
      contact_address { "1 High Street, Paignton, Devon" }
      contact_email { "my@email.com" }
      upcoming_court_case { "no" }
    end

    factory :information_request_for_self, traits: %i[for_self with_subject_id]
    factory :information_request_for_other, traits: %i[for_other]
    factory :information_request_by_solicitor, traits: %i[for_other by_solicitor with_consent]
    factory :information_request_by_friend, traits: %i[for_other by_friend with_consent with_requester_id with_requester_address with_subject_id]
    factory :information_request_with_consent, traits: %i[for_other with_consent]
    factory :information_request_with_requester_id, traits: %i[for_other with_requester_id with_requester_address]
    factory :information_request_with_subject_id, traits: %i[for_other with_subject_id]
    factory :information_request_for_prison_service, traits: %i[for_self prison_service]
    factory :information_request_for_probation_service, traits: %i[for_self probation_service]
    factory :information_request_for_laa, traits: %i[for_self laa]
    factory :information_request_for_opg, traits: %i[for_self opg]
    factory :information_request_for_moj_other, traits: %i[for_self moj_other]
    factory :complete_request, traits: %i[for_self with_subject_id prison_service probation_service with_contact]
  end
end
