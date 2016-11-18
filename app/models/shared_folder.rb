class SharedFolder < ApplicationRecord

  belongs_to :user
  belongs_to :shared_user, :class_name => "User", :foreign_key => "shared_user_id"

  belongs_to :folder

end
