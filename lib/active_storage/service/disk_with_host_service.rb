require "active_storage/service/disk_service"

class ActiveStorage::Service::DiskWithHostService < ActiveStorage::Service::DiskService
  def url_options
    { host: "https://www.example.com" }
  end
end
