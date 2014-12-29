FactoryGirl.define do
  factory :wemo_switch do
    ip_address '127.0.0.1'
    serial_number SecureRandom.hex(5)
    port 12345
    friendly_name "Switch #{SecureRandom.hex(2)}"
  end
end