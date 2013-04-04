# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Topic < ActiveRecord::Base
  has_many :rooms
  attr_accessible :title

  def self.top_popular
    
    # this sucks
    # it should be a crazy sql query, but i suck at sql. steve you do this : )
    poptop = []
    Topic.all.each do |topic|
      total = topic.debaters + topic.observers
      poptop << [topic, total]
    end
    poptop.sort! { |a,b| a[1] <=> b[1] }
    poptop.collect { |a| a[0] }.reverse[0..5]

  	# Topic.find_by_sql("SELECT topics.id, topics.title, sum(case when user_sessions.observing = '1' then 1 else 0 end) as observer_count, sum(case when user_sessions.observing = '0' then 1 else 0 end) as debater_count, count(rooms.id) as room_count FROM topics left join rooms on rooms.topic_id = topics.id left join user_sessions on (user_sessions.topic_id = topics.id and user_sessions.room_id = rooms.id) GROUP BY topics.id, topics.title, rooms.topic_id ORDER BY room_count desc LIMIT 5")
  end

  def self.sort_all(params)
    topics = Topic.all.reverse
    # topics = Topic.find_by_sql("SELECT topics.id, topics.title, sum(case when user_sessions.observing = '1' then 1 else 0 end) as observer_count, sum(case when user_sessions.observing = '0' then 1 else 0 end) as debater_count, count(rooms.id) as room_count FROM topics left join rooms on rooms.topic_id = topics.id left join user_sessions on (user_sessions.topic_id = topics.id and user_sessions.room_id = rooms.id) GROUP BY topics.id, topics.title ORDER BY topics.id desc")
  end

  def debaters
    agree_debaters + disagree_debaters
  end

  def agree_debaters
    rooms.collect {|r| r.agree}.compact.count
  end

  def disagree_debaters
    rooms.collect {|r| r.disagree}.compact.count
  end

  def observers
    rooms.inject(0) {|i,r| i += r.observers.count }
  end

end
