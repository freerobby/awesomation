class Announcement
  FEMALE_VOICES = %w(agnes kathy princess vicki victoria)
  MALE_VOICES = %w(alex bruce fred junior ralph)
  NOVELTY_VOICES = %w(albert bad_news bahh bells boing bubbles cellos deranged
    good_news hysterical pipe_organ trinoids whisper zarvox)

  ALL_VOICES = FEMALE_VOICES + MALE_VOICES + NOVELTY_VOICES

  @@player_threads = []

  def self.random_voice
    ALL_VOICES.sample
  end


  def self.say(statement, voice = random_voice, words_per_minute = 180)
    command = %Q(say "#{statement.gsub('"', '')}" -v "#{voice.to_s.titleize}" -r #{words_per_minute})
    `#{command}`
    true
  end


  def self.play_youtube_audio(url, volume = 1.0, skip_frames = 0)
    scale = (32768 * volume).to_i
    command = %Q(wget -q -O - `youtube-dl -g #{url}` | ffmpeg -i - -f mp3 -vn -acodec libmp3lame - | mpg123 -k #{skip_frames} --scale #{scale} -)
    stop_youtube_audio
    @@player_threads << Thread.new do
      `#{command}`
    end
    true
  end


  def self.stop_youtube_audio
    puts @@player_threads.inspect
    @@player_threads.each do |t|
      Thread.kill(t)
    end
  end
end