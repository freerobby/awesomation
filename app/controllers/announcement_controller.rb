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

end
