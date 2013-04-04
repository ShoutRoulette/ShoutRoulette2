# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  session_id :string(255)
#  topic_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  agree      :boolean
#  disagree   :boolean
#

class Room < ActiveRecord::Base
  belongs_to :topic
  has_many :observers
  attr_accessible :session_id, :agree, :disagree, :closed

  def self.create_or_join(topic, params, request)

    if params[:position] == 'observe'
      selected_room = Room.find_observable_room(topic)
    else
      # find a room with an open seat for your position
      throw 'dont hack me bro' unless params[:position ] == 'agree' or params[:position] == 'disagree' 
    	selected_room = Room.where("#{params[:position]} is null and topic_id = '#{topic.id}'").shuffle.first

      # if there isn't one, create one. if there is, fill the position
      if !selected_room
        selected_room = topic.rooms.create({ session_id: OTSDK.createSession.to_s, :"#{params[:position]}" => true })
      else
        selected_room.update_attribute params[:position], true
      end
    end

    # return the room
    selected_room

  end

  def close(position, observer_id)
    if position == 'observe'
      Observer.find(observer_id).destroy
    else
      update_attribute position, nil
    end
    self.destroy if agree.nil? and disagree.nil?
  end

  def add_observer
    observers.create
  end

  def self.find_observable_room(topic)
    room = Room.where("agree is not null and disagree is not null and topic_id = ?", topic.id).shuffle.first
    return room unless room.nil?
    Room.where("agree is not null or disagree is not null and topic_id = ?", topic.id).shuffle.first
  end

  def self.publisher_token(session)
    OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::PUBLISHER
  end

  def self.subscriber_token(session)
    OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::SUBSCRIBER
  end

end
