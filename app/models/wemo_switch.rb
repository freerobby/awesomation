require 'playful/ssdp'
class WemoSwitch < ActiveRecord::Base
  SEARCH_TARGET = 'urn:Belkin:device:controllee:1'


  validates_uniqueness_of :serial_number
  validates_uniqueness_of :ip_address


  def self.discover_devices
    Playful::SSDP.search(SEARCH_TARGET).uniq.map do |device|
      ip_address, port = device[:location].match(/http:\/\/(\d+\.\d+\.\d+\.\d+):(\d+)/).captures
      {ip_address: ip_address, port: port, setup_uri: device[:location]}
    end
  end


  def self.create_devices
    devices = []
    discover_devices.each do |device|
      setup = Net::HTTP.get(URI.parse(device[:setup_uri]))
      device_attrs = Hash.from_xml(setup)

      existing_device = find_by_serial_number(device_attrs['root']['device']['serialNumber'])
      if existing_device
        devices << existing_device
      else
        devices << create!(
          friendly_name: device_attrs['root']['device']['friendlyName'],
          serial_number: device_attrs['root']['device']['serialNumber'],
          ip_address: device[:ip_address],
          port: device[:port]
        )
      end
    end

    devices
  end
end
