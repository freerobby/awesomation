class GithubController < ApplicationController
  def receive
    log(request.body.read)
    render text: 'OK'
  end
end
