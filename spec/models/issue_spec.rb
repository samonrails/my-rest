# == Schema Information
#
# Table name: issues
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  description  :text
#  priority     :string(255)
#  subject_id   :integer
#  subject_type :string(255)
#  assignee_id  :integer
#  assigner_id  :integer
#  open_date    :datetime
#  due_date     :datetime
#  status       :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Issue do

  let (:issue) { create(:issue) }

  it "has a valid factory" do
    issue.should be_valid
  end

  it "is invalid without a title" do
    new_issue = build(:issue, title: nil)
    new_issue.should_not be_valid
    new_issue.errors.messages[:title].should be_include "can't be blank"
  end

  it "is invalid without a assigner" do
    new_issue = build(:issue, assigner: nil)
    new_issue.should_not be_valid
    new_issue.errors.messages[:assigner_id].should be_include "can't be blank"
  end

  it "is invalid without a assigner" do
    new_issue = build(:issue, assignee: nil)
    new_issue.should_not be_valid
    new_issue.errors.messages[:assignee_id].should be_include "can't be blank"
  end

  it "is invalid without a subject" do
    new_issue = build(:issue, subject: nil)
    new_issue.should_not be_valid
    new_issue.errors.messages[:subject].should be_include "can't be blank"
  end

  it "must contain priority value in (High,Normal,Low)" do
    new_issue = build(:issue, priority: "Critical")
    new_issue.should_not be_valid
    new_issue.errors.messages[:priority].should be_include "can be Low/Normal/High only"
  end

  it "should have a user as assignee and assigner" do
    issue.assignee.class.should be User
    issue.assigner.class.should be User
  end
  
  it "should have a vendor/account/event as subject" do
    [Account, Vendor, Event].should include issue.subject.class
  end

  it "should touch open date after create" do
    new_issue = Issue.new(title: "test title", description: "test description", assigner: issue.assigner, assignee: issue.assignee, priority: "Normal", subject: issue.subject)
    new_issue.open_date.should be nil
    new_issue.save!
    new_issue.open_date.should_not be nil
  end

  xit "should send email to assignee after create" do
    new_issue = Issue.create!(title: "test title", description: "test description", assigner: issue.assigner, assignee: issue.assignee, priority: "Normal", subject: issue.subject)
    ActionMailer::Base.deliveries.last.to.should include new_issue.assignee.email
  end
end
