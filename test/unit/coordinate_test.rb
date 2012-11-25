# == Schema Information
#
# Table name: coordinates
#
#  id            :integer          not null, primary key
#  cell_id       :integer
#  image_id      :integer
#  experiment_id :integer
#  x             :integer
#  y             :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class CoordinateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
