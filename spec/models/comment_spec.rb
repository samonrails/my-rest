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

require 'spec_helper'

describe Comment do

  let (:comment) { create(:comment) }

  it "has a valid factory" do
    comment.should be_valid
  end

  it "is invalid without description" do
    new_comment = build(:comment, description: nil)
    new_comment.should_not be_valid
    new_comment.errors.messages[:description].should be_include "can't be blank"
  end

  it "is invalid without a user" do
    new_comment = build(:comment, user: nil)
    new_comment.should_not be_valid
    new_comment.errors.messages[:user_id].should be_include "can't be blank"
  end

  it "is invalid without a issue" do
    new_comment = build(:comment, issue: nil)
    new_comment.should_not be_valid
    new_comment.errors.messages[:issue_id].should be_include "can't be blank"
  end

  it "is associated with user" do
    comment.user.class.should be User
  end

  it "is associated with issue" do
    comment.issue.class.should be Issue
  end
end
