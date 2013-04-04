# == Schema Information
#
# Table name: sessions
#
#  id           :integer          not null, primary key
#  topic_id     :integer
#  user_ip      :string(255)
#  user_session :string(255)
#  user_token   :text
#  room_session :text
#  position     :integer
#  matched      :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  last_update  :datetime
#

require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
