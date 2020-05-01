class ChatController < ApplicationController
  before_action :set_recipient, only: [:index, :show]
  before_action :set_sender, only: [:show]

  def show
    message_query = @sender ?
      Message.where(recipient: @recipient, sender: @sender) : Message.where(recipient: @recipient)

    @messages = message_query
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
