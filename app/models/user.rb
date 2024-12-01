class User < ApplicationRecord
  has_one :google_access_token
end
