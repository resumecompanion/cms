module Cms
  class User < ActiveRecord::Base

    devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

    attr_accessible :nickname, :email, :password, :password_confirmation, :remember_me

    validates :email, :password, :password_confirmation, :nickname, :presence => true

    has_many :files
    has_many :pages, :class_name => "Cms::Page", :foreign_key => :author_id
  end
end
