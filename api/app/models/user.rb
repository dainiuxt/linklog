# frozen_string_literal: true

class User < ApplicationRecord
  include BCrypt
  validates :login, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :password, presence: true, if: -> { provider == 'standard' }

  has_one :access_token, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy

  def password
    return if auth_data['encrypted_password'].blank?

    @password ||= Password.new(encrypted_password)
  end

  def password=(new_password)
    @password = new_password.present? ? Password.create(new_password) : nil
    auth_data['encrypted_password'] = @password
  end

  def encrypted_password
    auth_data['encrypted_password']
  end
end
