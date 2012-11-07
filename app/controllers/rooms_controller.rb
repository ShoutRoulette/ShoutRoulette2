class RoomsController < ApplicationController

  def show

    @topics = Topic.top_popular
    @topic = Topic.find(params[:id])
    pos = 0
    #to prevent sql injection, define position
    if params[:position].to_s == 'agree'
      @position = 'publisher'
      pos = 1
    elsif params[:position].to_s == 'disagree'
      pos = 2
      @position = 'publisher'
    elsif params[:position].to_s == 'observe'
      pos = 3
      @position = 'observer'
    end

    Session.reset_session(request, @topic.id, pos)
  end

  def find_room
    user = Session.check_session(request)
    render :json => user
  end

  def next_op
    Session.next_op(request)
    user = Session.check_session(request)
    render :json => user
  end

  def close
  	Room.find(params[:id]).close params[:position], params[:observer_id]
    if params[:position] != 'observe'
      session['shouting'] -= 1
    end
    render text: "room closed"
  end

end
