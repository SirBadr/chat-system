module Api
    module V1
        class ChatsController < ApplicationController
            # to mitigate rails token sessions that bug postman requests!
            protect_from_forgery with: :null_session
            
            # create new chat in an application
            def create
                # user must provide an Application token
                # params.require(:app_token)
                # get application
                puts params[:app_token]
                app = App.find(params[:app_token])
                puts app
                # create new chat record
                chat = Chat.new({app_token: params[:app_token], messages_count: 0, chat_id: app.chats_count + 1})
                app.update_attribute(:chats_count, app.chats_count + 1)

                if chat.save
                    render json: {status: "SUCCESS", message:"savedApp",data: app.chats_count}, status: :ok
                else
                    render json: {status: "FAILURE", message:"notSavedApp",data: {}}, status: :unprocessable_entity
                end
            end

            def show
                params.require(:app_token)
                chats = Chat.where(app_token: params[:app_token])

                if chats
                    render json: {status: "SUCCESS", message: "retrieved chats", data: chats}, status: :ok
                else
                    render json: {status: "FAILED", message: "couldn't retireve chats", data: {}}, status: :unprocessable_entity
                end
            end

        end
    end
end