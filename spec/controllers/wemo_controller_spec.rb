require_relative '../spec_helper'

describe WemoController do
  before do
    @switch = create :wemo_switch
    expect(WemoSwitch).to receive(:find).and_return(@switch)
  end
  it 'POST #on' do
    allow(@switch).to receive(:turn_on!)
    post :on, id: @switch.id
  end
  it 'POST #off' do
    allow(@switch).to receive(:turn_off!)
    post :off, id: @switch.id
  end
end
