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

require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
