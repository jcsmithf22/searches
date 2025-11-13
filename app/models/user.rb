class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :searches, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
