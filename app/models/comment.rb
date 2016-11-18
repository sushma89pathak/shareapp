class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  has_many :comments, :as => :commentable
  audited associated_with: :commentable
end
