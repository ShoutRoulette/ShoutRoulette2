class RoomsController < ApplicationController

  def show
    @topic = Topic.find(params[:id])
    @room = Room.create_or_join(@topic, params)
    @position = params[:position] == 'agree' ? "position_2" : "position_1"
  end

  def close
    @room = Room.find(params[:id])
  	@room.close(params[:position])
    render text: "room closed"
  end

end
