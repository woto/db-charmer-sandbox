class Post < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :categories

  scope :windows_posts, :conditions => "title like '%win%'"
  scope :dummy_scope, :conditions => '1'
end
