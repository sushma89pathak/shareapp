class Upload < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :folder, optional: true
  has_many :comments, as: :commentable

  audited associated_with: :user
  has_associated_audits

  has_attached_file :uploaded_file,
               :path => "assets/:id/:basename.:extension"

  validates_attachment_size :uploaded_file, :less_than => 10.megabytes
  validates_attachment_presence :uploaded_file
  validates_attachment_content_type :uploaded_file, :content_type => /^image\/(jpg|png)$/, :message => 'file type is not allowed (only jpeg/png/gif images)'

  belongs_to :folder

  # validates_attachment_content_type :uploaded_file, :content_type => ["image/jpg", "image/png"]
  def file_name
    uploaded_file_file_name
  end

  def file_size
    uploaded_file_file_size
  end
end
