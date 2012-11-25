# == Schema Information
#
# Table name: cells
#
#  id            :integer          not null, primary key
#  image_id      :integer
#  experiment_id :integer
#  path_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class CellTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
