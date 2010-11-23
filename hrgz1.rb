require 'httparty'
require 'uri'

class HRGZ1
  COMMAND_PREFIX = "goform/sendzwave?cmd="
  
  def initialize(host, port, username, password)
    @host = host
    @port = port
    @username = URI.encode(username)
    @password = URI.encode(password)
  end
  
  def turn_appliance_on(node)
    execute(get_command_url("SLVL #{node},1"))
  end
  def turn_appliance_off(node)
    execute(get_command_url("SLVL #{node},0"))
  end
  
  private
  def execute(url)
    HTTParty.get(url, {:basic_auth => {:username => @username, :password => @password}})
  end
  def get_command_url(cmd)
    "http://#{@host}:#{@port}/#{COMMAND_PREFIX}#{URI.encode(cmd)}"
  end
end