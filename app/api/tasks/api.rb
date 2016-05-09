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

      end
    end

    before do
      authenticate!
    end

    resources :tasks do
      post :run do
        { hello: 'world' }
      end
    end
  end
end
