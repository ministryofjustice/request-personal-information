Ratonvirus.configure do |config|
  config.scanner = Rails.env.local? ? :eicar : :clamby
  config.storage = :filepath
end
