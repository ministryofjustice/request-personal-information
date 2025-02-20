class AntiVirusValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?

    storage = Ratonvirus.storage
    return unless storage.accept?(value.path)

    scanner = Ratonvirus.scanner
    return unless scanner.available?

    return unless scanner.virus?(value.path)

    if scanner.errors.any?
      scanner.errors.each do |err|
        record.errors.add attribute, err
      end
    else
      record.errors.add attribute, :antivirus_virus_detected
    end
  end
end
