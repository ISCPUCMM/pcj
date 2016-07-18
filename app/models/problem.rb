class Problem < ActiveRecord::Base
  belongs_to :owner, class_name: :User

  validates_presence_of :name, :owner

  scope :owned_by, -> (user) { where(owner: user) }
end
