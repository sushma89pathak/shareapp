module ApplicationHelper
  def active?(path)
		"active" if current_page?(path)
	end
  private
  def number_of_people_who_also_answered_count option_id
    Survey::Answer.where(option_id: option_id).count
  end
end
