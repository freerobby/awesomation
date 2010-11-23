require 'sinatra'

require 'hrgz1'

helpers do
  def protected!
    unless ENV['BASICAUTH_USERNAME'].blank? || ENV['BASICAUTH_PASSWORD'].blank? # Disregard protection if no user/pass specified
      if !authorized?
        response['WWW-Authenticate'] = %(Basic realm="Testing HTTP Auth")
        throw(:halt, [401, "Not authorized\n"])
      end
    end
  end
  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [ENV['BASICAUTH_USERNAME'], ENV['BASICAUTH_PASSWORD']]
  end
end

get '/' do
  "Awesomation is running!"
end

# Turn a node on
get '/appliances/:node_id/on' do
  protected!
  new_gateway.turn_appliance_on(params[:node_id])
end

# Turn a node off
get '/appliances/:node_id/off' do
  protected!
  new_gateway.turn_appliance_off(params[:node_id])
end

private
def new_gateway
  HRGZ1.new(ENV['GATEWAY_HOST'], ENV['GATEWAY_PORT'], ENV['GATEWAY_USERNAME'], ENV['GATEWAY_PASSWORD'])
end