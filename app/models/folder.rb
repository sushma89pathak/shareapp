class Folder < ApplicationRecord
  acts_as_tree
  belongs_to :user
  has_many :uploads, :dependent => :destroy
  has_many :shared_folders, :dependent => :destroy

  audited associated_with: :user

  def shared?
    !self.shared_folders.empty?
  end

end
