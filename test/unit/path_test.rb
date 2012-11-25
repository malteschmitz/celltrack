# == Schema Information
#
# Table name: paths
#
#  id            :integer          not null, primary key
#  experiment_id :integer
#  tree_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class PathTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
