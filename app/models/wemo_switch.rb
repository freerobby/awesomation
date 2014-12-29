require 'playful/ssdp'
class WemoSwitch < ActiveRecord::Base
  SEARCH_TARGET = 'urn:Belkin:device:controllee:1'
  SERVICE_NAME = 'urn:Belkin:service:basicevent:1'

  validates_uniqueness_of :serial_number
  validates_uniqueness_of :ip_address


  def self.discover_devices
    Playful::SSDP.search(SEARCH_TARGET).uniq.map do |device|
      ip_address, port = device[:location].match(/http:\/\/(\d+\.\d+\.\d+\.\d+):(\d+)/).captures
      {ip_address: ip_address, port: port, setup_uri: device[:location]}
    end
  end


  def self.create_devices!
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

  def turn_on!
    set_state!('1') unless is_on?
    get_state
  end

  def turn_off!
    set_state!('0') unless is_off?
    get_state
  end

  private
  def device_uri
    "http://#{ip_address}:#{port}"
  end


  def set_state!(state)
    data = <<-EOS
      <?xml version="1.0" encoding="utf-8"?>
      <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
      <s:Body>
        <u:SetBinaryState xmlns:u="urn:Belkin:service:basicevent:1">
          <BinaryState>#{state}</BinaryState>
        </u:SetBinaryState>
      </s:Body>
      </s:Envelope>
    EOS
    headers = {
      'Content-Type' => 'text/xml; charset="utf-8"',
      'SOAPACTION' => %Q("#{SERVICE_NAME}#SetBinaryState")
    }
    http = Net::HTTP.new(ip_address, port)
    http.use_ssl = false
    path = '/upnp/control/basicevent1'
    resp, _ = http.post(path, data, headers)
    parseBinaryStateResponse(resp.body, 'SetBinaryStateResponse')
  end


  def get_state
    data = <<-EOS
      <?xml version="1.0" encoding="utf-8"?>
      <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
      <s:Body>
        <u:GetBinaryState xmlns:u="urn:Belkin:service:basicevent:1"></u:GetBinaryState>
      </s:Body>
      </s:Envelope>
    EOS
    headers = {
      'Content-Type' => 'text/xml; charset="utf-8"',
      'SOAPACTION' => %Q("#{SERVICE_NAME}#GetBinaryState")
    }
    http = Net::HTTP.new(ip_address, port)
    http.use_ssl = false
    path = '/upnp/control/basicevent1'
    resp, _ = http.post(path, data, headers)
    parseBinaryStateResponse(resp.body, 'GetBinaryStateResponse')
  end


  def parseBinaryStateResponse(resp, response_type)
    Hash.from_xml(resp)['Envelope']['Body'][response_type]['BinaryState']
  end


  def is_on?
    get_state == '1'
  end

  def is_off?
    !is_on?
  end
end
