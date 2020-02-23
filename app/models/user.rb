class User < ApplicationRecord
  has_many :merchant_employees
  has_many :merchants, through: :merchant_employees

  has_secure_password
  
  validates_presence_of :name, :street_address, :city, :state, :zip, :role, :password_digest
  validates :email, uniqueness: true, presence: true

  enum role: %w( User MerchantEmployee Admin )

end
