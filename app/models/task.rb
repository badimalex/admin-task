class Task < ActiveRecord::Base
  belongs_to :user
  has_many :attachments

  validates :name, :description, presence: true

  accepts_nested_attributes_for :attachments
end
