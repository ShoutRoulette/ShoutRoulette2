class TopicsController < ApplicationController

  def new
    Topic.create({ title: params[:topic] })
    logger.debug "^^^^^^^^^^^created new room homie ^^^^^^^^"
    redirect_to root_path
  end

end
