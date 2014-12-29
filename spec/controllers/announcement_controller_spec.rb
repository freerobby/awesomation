require_relative '../spec_helper'

describe AnnouncementController do
  it 'POST #say' do
    allow(Announcement).to receive(:say).with('Hi there!', 'zarvox', 300)
    post :say, statement: 'Hi there!', voice: 'zarvox', words_per_minute: 300
  end
end
