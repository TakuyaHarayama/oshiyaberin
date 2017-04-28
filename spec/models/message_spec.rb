# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  uid        :string
#  input_text :string
#  res_text   :string
#  res_status :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Message, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
