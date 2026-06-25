# spec/support/clamav.rb
RSpec.configure do |config|
  config.before do
    tcp_socket = instance_double(TCPSocket)
    allow(TCPSocket).to receive(:new).and_return(tcp_socket)
    allow(tcp_socket).to receive(:write)
    allow(tcp_socket).to receive(:read)

    clamav_client = instance_double(ClamAV::Client)
    allow(ClamAV::Client).to receive(:new).and_return(clamav_client)
    allow(clamav_client).to receive(:execute)
                              .and_return(ClamAV::SuccessResponse.new("/path/to/file"))
  end
end
