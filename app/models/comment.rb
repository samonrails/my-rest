# == Schema Information
#
# Table name: comments
#
#  id          :integer          not null, primary key
#  description :text
#  issue_id    :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Comment < ApplicationModel

  #Associations
  belongs_to :issue
  belongs_to :user

  #Validations
  validates :description, presence: true
  validates :issue_id, presence: true
  validates :user_id, presence: true

end