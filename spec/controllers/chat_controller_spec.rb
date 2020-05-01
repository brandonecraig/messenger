require 'rails_helper'

RSpec.describe ChatController do
  before do
    @recipient = "User 1"
    @sender = "User 2"
    @sender2 = "User 3"

    Message.create(recipient: @recipient, sender: @sender, body: "Hey friend!")
    Message.create(recipient: @sender, sender: @recipient, body: "Long time no see!")
    Message.create(recipient: @recipient, sender: @sender, body: "Want to grab coffee?")
    Message.create(recipient: @recipient, sender: @sender2, body: "What's new with you?")
  end

  describe "GET show" do
    it "returns messages from the specified sender" do
      params = { recipient: @recipient, sender: @sender }

      get :show, params: params

      parsed_body = JSON.parse(response.body)
      expect(parsed_body.count).to eq(3)
      expect(parsed_body.first["body"]).to eq("Hey friend!")
      expect(parsed_body.first["sender"]).to eq("User 2")

      expect(parsed_body.second["body"]).to eq("Long time no see!")
      expect(parsed_body.second["sender"]).to eq("User 1")

      expect(parsed_body.last["body"]).to eq("Want to grab coffee?")
      expect(parsed_body.last["sender"]).to eq("User 2")
    end
  end
end
