require 'rails_helper'

RSpec.describe MessagesController do
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
    it "returns messages for all senders if no sender id is given" do
      params = { recipient: @recipient }

      get :show, params: params

      parsed_body = JSON.parse(response.body)
      expect(parsed_body.count).to eq(3)

      expect(parsed_body.first["body"]).to eq("Hey friend!")
      expect(parsed_body.first["sender"]).to eq("User 2")

      expect(parsed_body.second["body"]).to eq("Want to grab coffee?")
      expect(parsed_body.second["sender"]).to eq("User 2")

      expect(parsed_body.last["body"]).to eq("What's new with you?")
      expect(parsed_body.last["sender"]).to eq("User 3")
    end

    it "returns messages from the specified sender" do
      params = { recipient: @recipient, sender: @sender }

      get :show, params: params

      parsed_body = JSON.parse(response.body)
      expect(parsed_body.count).to eq(2)
      expect(parsed_body.first["body"]).to eq("Hey friend!")
      expect(parsed_body.first["sender"]).to eq("User 2")

      expect(parsed_body.last["body"]).to eq("Want to grab coffee?")
      expect(parsed_body.last["sender"]).to eq("User 2")
    end

    it "doesn't include messages from over 30 days ago" do
      Timecop.freeze(31.days.ago) do
        Message.create(recipient: @recipient, sender: @sender, body: "Message from the way back")
      end

      params = { recipient: @recipient }
      get :show, params: params

      parsed_body = JSON.parse(response.body)
      messages = parsed_body.map { |b| b["body"] }
      expect(messages.size).to eq(3)
      expect(messages).to_not include("Message from the way back")
    end

    it "only includes the 100 most recent messages" do
      sender3 = "User 4"

      105.times do |i|
        Message.create(recipient: @recipient, sender: sender3, body: "Message #{i}")
      end

      params = { recipient: @recipient }
      get :show, params: params

      parsed_body = JSON.parse(response.body)
      messages = parsed_body.map { |b| b["body"] }

      expect(messages.size).to eq(100)
      expect(messages).to_not include("Message 0")
      expect(messages).to_not include("Message 1")
      expect(messages).to_not include("Message 2")
      expect(messages).to_not include("Message 3")
      expect(messages).to_not include("Message 4")
    end
  end

  describe "POST create" do
    it "creates a new message" do
      params = { message: { recipient: @recipient, sender: @sender, body: "Do you like tacos?" } }
      expect do
        post :create, params: params
      end.to change { Message.count }.by(1)

      parsed_body = JSON.parse(response.body)
      expect(parsed_body["sender"]).to eq(@sender)
      expect(parsed_body["recipient"]).to eq(@recipient)
      expect(parsed_body["body"]).to eq("Do you like tacos?")
    end

    it "returns errors when message cannot be created" do
      params = { message: { recipient: @recipient, sender: @sender } }
      post :create, params: params

      expect(response.code).to eq("422")
      parsed_body = JSON.parse(response.body)
      expect(parsed_body["body"]).to eq(["must be present"])
    end
  end
end
