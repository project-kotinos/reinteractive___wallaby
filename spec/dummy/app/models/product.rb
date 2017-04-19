class Product < ActiveRecord::Base
  has_one :product_detail
  has_one :picture, -> { where name: 'abc' }, as: :imageable
  has_many :order_items, class_name: Order::Item.name
  has_many :orders, through: :order_items
  belongs_to :category
  has_and_belongs_to_many :tags
end
