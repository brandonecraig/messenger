class Message < ApplicationRecord
  validates :recipient, :sender, :body, presence: { message: "must be present" }
end
