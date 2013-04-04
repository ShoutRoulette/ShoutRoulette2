class AdminController < ApplicationController
  http_basic_authenticate_with :name => "hello", :password => "world"

  def index
    @topics = Topic.all.reverse 
    @rooms = Room.all.reverse
    @sessions = Session.find(:all, :include => :topic, :order => "updated_at DESC")
  end

  def remove_topic
    @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to admin_path
  end

  def remove_all_rooms
  	@rooms.all.destroy

  	redirect_to admin_path
  end

  def remove_session 
  	@session = Session.find(params[:id])
  	@session.destroy
  	redirect_to admin_path
  end

  def remove_all_sessions 
  	Session.destroy_all
  	redirect_to admin_path
  end

  def remove_all_old_sessions
	Session.destroy_all(['updated_at < ?', 10.minutes.ago])
  	redirect_to admin_path
  end

end
