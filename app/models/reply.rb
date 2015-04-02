class Reply < ActiveRecord::Base
  attr_accessible :comment, :body
  belongs_to :comment, touch: true
end
