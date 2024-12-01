class User < ApplicationRecord
  has_one :google_access_token, dependent: :destroy

  has_many :google_calendars, dependent: :destroy
end
