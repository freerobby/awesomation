class WemoController < ApplicationController
  before_filter :load_switch
  skip_before_filter :verify_authenticity_token

  def on
    @switch.turn_on!
    render text: 'OK'
  end

  def off
    @switch.turn_off!
    render text: 'OK'
  end

  private
  def load_switch
    params.permit[:id]
    @switch = WemoSwitch.find(params[:id])
  end
end
