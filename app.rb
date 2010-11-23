require 'sinatra'

require 'hrgz1'

get '/' do
  "Awesomation is running!"
end

# Turn a node on
get '/appliance/:node_id/on' do
  new_gateway.turn_appliance_on(params[:node_id])
end

# Turn a node off
get '/appliance/:node_id/off' do
  new_gateway.turn_appliance_off(params[:node_id])
end

private
def new_gateway
  HRGZ1.new(ENV['GATEWAY_HOST'], ENV['GATEWAY_PORT'], ENV['GATEWAY_USERNAME'], ENV['GATEWAY_PASSWORD'])
end