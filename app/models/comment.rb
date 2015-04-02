class Comment < ActiveRecord::Base
  attr_accessible :body, :post
  belongs_to :post, touch: true
  has_many :replies, dependent: :destroy
end
