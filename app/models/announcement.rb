class Announcement
  FEMALE_VOICES = %w(agnes kathy princess vicki victoria)
  MALE_VOICES = %w(alex bruce fred junior ralph)
  NOVELTY_VOICES = %w(albert bad_news bahh bells boing bubbles cellos deranged
    good_news hysterical pipe_organ trinoids whisper zarvox)

  ALL_VOICES = FEMALE_VOICES + MALE_VOICES + NOVELTY_VOICES

  @@last_youtube_player_pid = nil

  def self.random_voice
    ALL_VOICES.sample
  end


  def self.say(statement, voice = random_voice, words_per_minute = 180)
    command = %Q(say "#{statement.gsub('"', '')}" -v "#{voice.to_s.titleize}" -r #{words_per_minute})
    `#{command}`
    true
  end


  def self.play_youtube_audio(url, volume = 1.0, skip_frames = 0)
    `youtube-dl -x #{url} -o "#{Rails.root}/tmp/#{'%(title)s.%(ext)s'}"`
    filename = `youtube-dl -x #{url} -o "#{Rails.root}/tmp/#{'%(title)s.%(ext)s'}" --get-filename`.chomp
    filename_wav = "#{filename}.wav"
    `ffmpeg -i "#{filename}" -acodec pcm_u8 -ar 22050 "#{filename_wav}" -y`
    stop_youtube_audio
    @@last_youtube_player_pid = Process.spawn(%Q(afplay "#{filename_wav}"))
    
    true
  end

  def self.stop_youtube_audio
    if @@last_youtube_player_pid
      Process.kill('TERM', @@last_youtube_player_pid)
      @@last_youtube_player_pid = nil
    end
  end
end