class WemoController < ApplicationController
  before_filter :load_switch
  skip_before_filter :verify_authenticity_token

  def on
    @switch.turn_on!
    render text: 'OK'
  end

  # Use Github web hook API to detect a push to master
  def on_if_master_push
    @switch.turn_on! if params[:ref] && params[:ref] == 'refs/heads/master'
    render text: 'OK'
  end

  def off
    @switch.turn_off!
    render text: 'OK'
  end

  def timer
    params.require(:time)
    @switch.timer!(params[:time].to_i)
    render text: 'OK'
  end

  private
  def load_switch
    params.permit[:id]
    @switch = WemoSwitch.find(params[:id])
  end
end
