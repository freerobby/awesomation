require_relative '../spec_helper'

describe AnnouncementController do
  it 'POST #say' do
    allow(Announcement).to receive(:say).with('Hi there!', 'zarvox', 300)
    post :say, statement: 'Hi there!', voice: 'zarvox', words_per_minute: 300
  end

  it 'POST #play_youtube_audio' do
    allow(Announcement).to receive(:play_youtube_audio).with('http://foo.bar')
    post :play_youtube_audio, url: 'http://foo.bar'
  end
end
