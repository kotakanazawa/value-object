class User < ApplicationRecord
  # serialize :address, Address

  validates :address, presence: true
end
