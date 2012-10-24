class Session < ActiveRecord::Base
  belongs_to :topic
  attr_accessible :user_ip, :user_session, :user_token, :room_session, :position, :matched
  #postiion: 0-not in room, 1-agree, 2-disagree, 3-observe

  def self.check_session(request)
  	user = Session.find_by_user_session(request.session_options[:id])
  	if user.position == 1 || user.position == 2
	  	if user.matched
	  		#user matched, generate token, go to room
	  		user.user_token = Session.publisher_token(user.room_session)
	  	else
	  		#find oponent
	  		find_pos = (user.position == 1) ? 2 : 1
        logger.info "ppppooooosssss"+find_pos.to_s
	  		#change order by rand to limit (rand numer), 1 in future
	  		op = Session.where("matched = false and topic_id = '#{user.topic_id}' and position = '#{find_pos}' and DATE(updated_at) >=  (DATE('#{Time.now}') - INTERVAL '7 SECONDS')").order("random()").first
	  		if !op.nil?
	  			sess = OTSDK.createSession.to_s
	  			op.room_session = sess
	  			op.matched = true
	  			op.save
	  			user.room_session = sess
	  			user.user_token = Session.publisher_token(user.room_session)
	  			user.matched = true
	  		end
	  	end
      user.last_update = Time.now
	  	user.save
	end
	user
  end

  def self.reset_session(request, topic_id, position)
  	user = Session.find_by_user_session(request.session_options[:id])
  	user = Session.create(:user_ip => request.remote_ip, :user_session => request.session_options[:id]) unless !user.nil?
  	user.topic_id = topic_id
  	user.room_session = ''
  	user.user_token = ''
  	user.matched = false
  	user.position = position
    user.last_update = Time.now
  	user.save
  end

  def self.publisher_token(session)
    OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::PUBLISHER
  end

  def self.subscriber_token(session)
    OTSDK.generateToken :session_id => session, :role => OpenTok::RoleConstants::SUBSCRIBER
  end
end
