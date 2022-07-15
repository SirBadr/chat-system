module Api
    module V1
        class MessagesController < ApplicationController
            # to mitigate rails token sessions that bug postman requests!
            protect_from_forgery with: :null_session
            
            # create new chat in an application
            def create
                # user must provide an Application token
                params.require(:app_token)
                params.require(:chat_id)
                params.require(:body)
                
                # get chat
                chat = Chat.find_by(["chat_id = :id and app_token = :token", {id: params[:chat_id], token: params[:app_token]}])
                puts chat
                # create new message record
                message = Message.new({chat_id: params[:chat_id], body: params[:body], app_token: params[:app_token]})
                chat.update_attribute(:messages_count, chat.messages_count + 1)

                if message.save
                    render json: {status: "SUCCESS", message:"saved message",data: message}, status: :ok
                else
                    render json: {status: "FAILURE", message:"not saved message",data: {}}, status: :unprocessable_entity
                end
            end

            def index
                #messages = Message.where({app_token: params[:app_token], chat_id: params[:chat_id]})
                messages = Message.where(["app_token = :id and chat_id = :token", {id: params[:app_token], token: params[:chat_id]}])
                render json: {status: "SUCCESS", message: "retrieved messages", data: messages}, status: :ok
            end


            def show
                unless params[:query].blank?
                    results = Message.search( params[:query] )
                    puts results
                    render json: {status:"SUCCESS", message:"take ur resp", data: results}, status: :ok
                end
            end

            #def update
            #    message = Message.find_by!(["chat_id = :id and app_token = :token", {id: params[:chat_id], token: params[:app_token]}])
            #    message.update(message_params)
            #end

            #private
            #def message_params
            #    params.permit(:app_token, :chat_id)
            #end

        end
    end
end