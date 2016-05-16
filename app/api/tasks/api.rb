module Tasks
  class API < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    helpers do
      def authenticate!
        error!('401   Unauthorized', 401) unless authorized?
      end

      def authorized?
        params[:token].eql? Judge::Application.config.api_token
      end
    end

    before do
      authenticate!
    end

    resources :tasks do

      params do
        requires :token, type: String
        requires :code, type: String
        requires :input, type: String
        requires :time_limit, type: Integer
        requires :language, type: String
      end
      post :run do
        Task.new(params.slice(:time_limit, :code, :input)).run
      end

      #THIS WILL ENQUEUE A DELAYED TASK TO RUN THE CODE
      post :judge do
      end
    end
  end
end
