class ChatController < ApplicationController
  before_action :set_recipient, only: [:show]
  before_action :set_sender, only: [:show]

  def show
    participants = [@recipient, @sender]
    @messages = Message.where(recipient: participants, sender: participants)
      .order(created_at: :asc)
      .where("created_at > ?", 30.days.ago)
      .last(100)

    render json: @messages
  end

  private
    def set_sender
      @sender = params[:sender]
    end

    def set_recipient
      @recipient = params[:recipient]
    end
end
