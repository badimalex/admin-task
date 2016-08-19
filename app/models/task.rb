class Task < ActiveRecord::Base
  belongs_to :user
  has_many :attachments, dependent: :destroy

  scope :latest, -> { order('created_at DESC') }

  validates :name, :description, :state, presence: true

  accepts_nested_attributes_for :attachments

  state_machine :state, initial: :new do
    state :started, :finished

    event :start do
      transition :new=>:started
    end

    event :finish do
      transition :started=>:finished
    end
  end
end
