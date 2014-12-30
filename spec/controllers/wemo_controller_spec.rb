require_relative '../spec_helper'

describe WemoController do
  before do
    @switch = create :wemo_switch
  end
  it 'POST #on' do
    allow(@switch).to receive(:turn_on!)
    post :on, id: @switch.id
  end
  it 'POST #off' do
    allow(@switch).to receive(:turn_off!)
    post :off, id: @switch.id
  end
  it 'POST #timer' do
    allow(@switch).to receive(:timer!).with(5)
    post :timer, id: @switch.id, time: 5
  end
end
