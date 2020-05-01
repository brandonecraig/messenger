class MessagesController < ApplicationController
  before_action :set_recipient, only: [:show]
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

  def create
    @message = Message.new(message_params)

    if @message.save
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private
    def set_sender
      @sender = params[:sender]
    end

    def set_recipient
      @recipient = params[:recipient]
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:body, :sender, :recipient)
    end
end
