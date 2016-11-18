class UserMailer < ApplicationMailer
  default :from => "sushma1989@gmail.com"

  def invitation_to_share(shared_folder)
    @shared_folder = shared_folder
    mail( :to => @shared_folder.shared_email,
          :subject => "#{@shared_folder.user.email} wants to share '#{@shared_folder.folder.name}' folder with you" )
  end
end
