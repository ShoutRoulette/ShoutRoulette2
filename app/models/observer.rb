# == Schema Information
#
# Table name: observers
#
#  id         :integer          not null, primary key
#  room_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Observer < ActiveRecord::Base
  belongs_to :room
end
