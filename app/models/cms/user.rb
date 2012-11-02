module Cms
  class User < ActiveRecord::Base

    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

    attr_accessible :nickname, :email, :password, :password_confirmation, :remember_me

    validates :email, :password, :password_confirmation, :nickname, :presence => true
  end
end
