require 'spec_helper'

describe IssuesController do

  before(:each) do
    sign_in_user
    request.env['HTTPS'] = 'on'
  end

  describe "GET #index" do 

    it "populates an array of issues" do
      get :index
      expect(response).to be_success
      expect_response_code 200
    end
  end

  describe "Post 'create'" do
    it "should create issue for" do
      subject = FactoryGirl.create(:vendor)
      assignee = FactoryGirl.create(:user)
      post :create, :issue => {:title => "Test Title 1", :description => "Test description 1", :priority => "Normal", :assigner_id => @user.id, :assignee_id => assignee.id},  :subject_type => subject.class, :subject_id => subject.id
      expect_response_code 302
      expect_redirect_to("/vendors/#{subject.id}?selected=issues")
    end

  end

  describe "Put 'update'" do
    it "should update issue" do
      issue = FactoryGirl.create(:issue)
      put :update, :issue => {:title => issue.title, :description => issue.description, :priority => "Normal", :assigner_id => issue.assigner_id, :assignee_id => issue.assignee_id},  :subject_type => issue.subject_type, :subject_id => issue.subject_id, :id => issue.id
      expect_response_code 302
      expect_redirect_to("/#{issue.subject.class.name.downcase}s/#{issue.subject.id}?selected=issues")
    end

  end

end
