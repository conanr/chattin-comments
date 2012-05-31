class Comment < ActiveRecord::Base
  validates_presence_of :text, unless: "text && text.empty?"
  validates_presence_of :user_id
  validates_presence_of :presentation_id
end
