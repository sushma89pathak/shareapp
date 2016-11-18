class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_surveys
  has_many :uploads
  has_many :folders
  has_many :shared_folders, :dependent => :destroy
  has_many :being_shared_folders, :class_name => "SharedFolder", :foreign_key => "shared_user_id", :dependent => :destroy
  has_many :shared_folders_by_others, :through => :being_shared_folders, :source => :folder

  has_associated_audits

  validates :email, :presence => true, :uniqueness => true

  after_create :check_and_assign_shared_ids_to_shared_folders

  def check_and_assign_shared_ids_to_shared_folders
      shared_folders_with_same_email = SharedFolder.where("shared_email = '#{self.email}' ")

      if shared_folders_with_same_email
        shared_folders_with_same_email.each do |shared_folder|
          shared_folder.shared_user_id = self.id
          shared_folder.save
        end
      end
  end

  def has_share_access?(folder)
    return true if self.folders.include?(folder)
    return true if self.shared_folders_by_others.include?(folder)
    return_value = false

    folder.ancestors.each do |ancestor_folder|

      return_value = self.being_shared_folders.include?(ancestor_folder)
      if return_value
        return true
      end
    end

    return false
end
end
