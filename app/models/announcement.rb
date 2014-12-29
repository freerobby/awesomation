class Announcement
  FEMALE_VOICES = %w(agnes kathy princess vicki victoria)
  MALE_VOICES = %w(alex bruce fred junior ralph)
  NOVELTY_VOICES = %w(albert bad_news bahh bells boing bubbles cellos deranged
    good_news hysterical pipe_organ trinoids whisper zarvox)

  ALL_VOICES = FEMALE_VOICES + MALE_VOICES + NOVELTY_VOICES

  def self.random_voice
    ALL_VOICES.sample
  end

  def self.say(statement, voice = random_voice, words_per_minute = 180)
    command = %Q(say "#{statement.gsub('"', '')}" -v "#{voice.to_s.titleize}" -r #{words_per_minute})
    `#{command}`
    true
  end
end