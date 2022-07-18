module Api
    module V1
        class ApplicationsController < ApplicationController
            # to mitigate rails token sessions that bug postman requests!
            protect_from_forgery with: :null_session
            
            # create new application with `name` as required parameter
            def create
                # user must provide an Application name
                params.require(:name)
                # create a unique random hex token for new apps.
                randTok = SecureRandom.hex
                # loops till we have a unique token value.
                loop do
                    randTok = SecureRandom.hex
                    break randTok unless App.where(token: randTok).exists?
                end
                # create new app record
                app = App.new({token: randTok, name: params[:name], chats_count: 0})
                
                if app.save
                    Publisher.publish(app);

                    render json: {status: "SUCCESS", message:"savedApp",data: app.token}, status: :ok
                else
                    render json: {status: "FAILURE", message:"notSavedApp",data: {}}, status: :unprocessable_entity
                end
            end

            # patch request to update application name!
            def update
                params.require(:new_name)
                app = App.find(params[:app_token])
                
                #if app.exists?
                    if app.update_attribute(:name, params[:new_name])
                        render json: {status: "SUCCESS", message:"App name updated successfully",data: {}}, status: :ok
                    else
                        render json: {status: "FAILURE", message:"app is not updated",data: {}}, status: :unprocessable_entity                
                    end   
                #else
                #    render json: {status: "FAILURE", message:"app doesn't exist",data: {}}, status: :unprocessable_entity                
                #end
            end

            def show
                app = App.find(params[:app_token])
                render json: {status: "SUCCESS", message: "loaded App", data: app}, status: :ok
            end

            private
            
            def update_params
                params.permit(:app_token, :new_name)
            end

        end
    end
end
