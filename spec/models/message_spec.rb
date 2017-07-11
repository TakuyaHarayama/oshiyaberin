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
  describe 'validation' do
    context 'with invalid uid' do
      let(:uid) { '' }
      it { is_expected.to be_valid }
    end
  end
end
