class AnnouncementController < ApplicationController
  skip_before_filter :verify_authenticity_token


  def say
    params.require(:statement)
    params.permit([:voice, :words_per_minute])

    if params[:words_per_minute]
      Announcement.say(params[:statement], params[:voice], params[:words_per_minute].to_i)
    elsif params[:voice]
      Announcement.say(params[:statement], params[:voice])
    else
      Announcement.say(params[:statement])
    end

    render text: 'OK'
  end


  def play_youtube_audio
    params.require(:url)
    params.permit(:volume)

    if params[:volume]
      Announcement.play_youtube_audio(params[:url], params[:volume].to_f)
    else
      Announcement.play_youtube_audio(params[:url])
    end

    render text: 'OK'
  end


  def stop_youtube_audio
    Announcement.stop_youtube_audio
    render text: 'OK'
  end

end
