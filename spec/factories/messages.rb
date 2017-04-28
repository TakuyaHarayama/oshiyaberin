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

FactoryGirl.define do
  factory :message do
    uid "MyString"
    input_text "MyString"
    res_text "MyString"
    res_status "MyString"
  end
end
