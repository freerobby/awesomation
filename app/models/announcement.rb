class Announcement
  FEMALE_VOICES = %w(agnes kathy princess vicki victoria)
  MALE_VOICES = %w(alex bruce fred junior ralph)
  NOVELTY_VOICES = %w(albert bad_news bahh bells boing bubbles cellos deranged
    good_news hysterical pipe_organ trinoids whisper zarvox)

  ALL_VOICES = FEMALE_VOICES + MALE_VOICES + NOVELTY_VOICES

  @@last_youtube_player_pid = nil

  class << self
    def random_voice
      ALL_VOICES.sample
    end


    def say(statement, voice = random_voice, words_per_minute = 180)
      command = %Q(say "#{statement.gsub('"', '')}" -v "#{voice.to_s.titleize}" -r #{words_per_minute})
      `#{command}`
      true
    end


    def play_youtube_audio(url)
      `youtube-dl -x #{url} -o "#{Rails.root}/tmp/#{'%(title)s.%(ext)s'}"`
      filename = `youtube-dl -x #{url} -o "#{Rails.root}/tmp/#{'%(title)s.%(ext)s'}" --get-filename`.chomp
      filename_wav = "#{filename}.wav"
      t = timestamp_from_youtube_url(url)
      `ffmpeg -ss #{t} -i "#{filename}" -acodec pcm_u8 -ar 22050 "#{filename_wav}" -y`
      stop_youtube_audio
      @@last_youtube_player_pid = Process.spawn(%Q(afplay "#{filename_wav}"))

      true
    end


    def stop_youtube_audio
      if @@last_youtube_player_pid
        Process.kill('TERM', @@last_youtube_player_pid)
        @@last_youtube_player_pid = nil
      end
    end


    private


    def timestamp_from_youtube_url(url)
      # Youtube supports specifying time by both fragment identifier and
      # by query string. Gives precedence to fragment, so that's what we
      # will do here as well.
      param_string = URI(url).fragment || URI(url).query
      t_string = CGI.parse(param_string)['t'].first

      t_string.split(/[^0-9]/).reverse.each_with_index.reduce(0) do |seconds, (val, index)|
        if index == 0 # seconds
          seconds += Integer(val)
        elsif index == 1 # minutes
          seconds += Integer(val) * 60
        elsif index == 2 # hours
          seconds += Integer(val) * 60 * 60
        else # something went terribly wrong
          raise "wat"
        end
      end
    rescue
      0
    end
  end
end
