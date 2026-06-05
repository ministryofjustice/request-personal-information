class AntiVirusValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?

    path = value.path
    return unless path.present? && File.exist?(path)

    client = build_client
    response = client.execute(ClamAV::Commands::ScanCommand.new(path)).first

    case response
    when ClamAV::VirusResponse
      record.errors.add(attribute, :antivirus_virus_detected)
    when ClamAV::ErrorResponse
      raise RequestsController::ClientProcessingError
    end
  rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT, Errno::ENOENT
    raise RequestsController::ClientProcessingError
  end

private

  def build_client
    ClamAV::Client.new(
      ClamAV::Connection.new(
        socket: ::TCPSocket.new(
          ENV.fetch("CLAMD_TCP_HOST", "request-personal-information-clamav-service"),
          ENV.fetch("CLAMD_TCP_PORT", 3310).to_i,
        ),
        wrapper: ClamAV::Wrappers::NewLineWrapper.new,
      ),
    )
  end
end
