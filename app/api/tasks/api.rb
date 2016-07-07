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
        task = Runner.new(params.slice(:code, :input, :time_limit, :language))

        if task.valid?
          task.commit
        else
          error!('422 Unable to run task', 422)
        end
      end

      params do
        requires :token, type: String
        requires :code, type: String
        requires :problem_id, type: Integer
        requires :time_limit, type: Integer
        requires :language, type: String
      end
      post :generate_outputs do
        task = OutputGenerator.new(params.slice(:code, :time_limit, :language, :problem_id))

        if task.valid?
          task.commit
        else
          error!('422 Unable to run task', 422)
        end
      end

      params do
        requires :token, type: String
        requires :time_limit, type: Integer
        requires :language, type: String
        requires :file_key, type: String
        requires :submission_id, type: Integer
        requires :problem_id, type: Integer
        optional :checker_key, type: String
        optional :checker_language, type: String
      end
      post :judge do
        if(task = Grader.create(params.slice(:time_limit, :language, :file_key, :submission_id, :problem_id)))
          res = task.commit
          byebug
          { status: 'enqueued' }
        else
          error!('422 Unable to create task', 422)
        end
      end
    end
  end
end
