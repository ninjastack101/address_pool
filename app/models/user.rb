class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def generate_access_token
    access_token = Doorkeeper::AccessToken.new(
      resource_owner_id: id,
      use_refresh_token: true,
      expires_in: Doorkeeper.configuration.access_token_expires_in
    )
    return access_token if access_token.save
    access_token.errors.full_messages.first
  end
end
