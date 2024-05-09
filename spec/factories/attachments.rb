FactoryBot.define do
  factory :attachment do
    key { "letter_of_consent" }
    file { Rack::Test::UploadedFile.new("spec/fixtures/files/file.jpg", "image/jpg") }
  end
end
