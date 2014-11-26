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

class Issue < ApplicationModel

  #Associations
  has_many :comments, dependent: :destroy
  belongs_to :subject, polymorphic: true
  belongs_to :assignee, foreign_key: 'assignee_id', class_name: 'User'
  belongs_to :assigner, foreign_key: 'assigner_id', class_name: 'User'

  #Validations
  validates :title, presence: true
  validates :assignee_id, presence: true
  validates :assigner_id, presence: true
  validates :subject, presence: true
  validates :priority, inclusion: { in: %w(High Normal Low), message: "can be Low/Normal/High only" }

  #Callbacks
  after_create :touch_open_date
  after_save :send_email_to_assignee

  scope :open, where(:status => true)
  scope :closed, where(:status => false)

  def touch_open_date
    self.touch :open_date
  end

  def send_email_to_assignee
    Notifier.send_issue_to_assignee(self).deliver if self.assignee_id_changed?
  end

  #Instance Methods

  def to_s
    title
  end

  def pretty_id
    "#{self.id.to_s.rjust(7, "0")}"
  end
end