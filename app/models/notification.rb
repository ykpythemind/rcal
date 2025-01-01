class Notification < ApplicationRecord
  belongs_to :user

  scope :unread, -> { where(read: false) }

  enum :notification_type, %i[authorize_needed]

  def mark_as_read!
    update!(read: true)
  end
end
