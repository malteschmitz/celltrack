# == Schema Information
#
# Table name: trees
#
#  id            :integer          not null, primary key
#  experiment_id :integer
#  root_path_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class TreeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
