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
        raise RequestsController::ClientProcessingError if err == :antivirus_client_error

        record.errors.add attribute, err
      end
    end
  end
end
