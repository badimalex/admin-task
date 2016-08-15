class Task < ActiveRecord::Base
  belongs_to :user
  has_many :attachments

  validates :name, :description, :state, presence: true

  accepts_nested_attributes_for :attachments

  state_machine :state, initial: :new do
    state :started, :finished
  end
end
