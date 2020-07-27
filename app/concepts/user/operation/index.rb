module User::Operation
  class Index < Trailblazer::Operation

    step :is_request_valid?
    step :fetch_users
    fail :set_error_message
    step :set_success_object
    
    def is_request_valid?(ctx, params:, **)
      params[:is_valid]
    end
    
    def fetch_users(ctx, **)
      @users = User.all
    end

    def set_error_message(ctx, **)
      ctx[:error] = { error: "Invalid request" }
    end

    def set_success_object(ctx, **)
      ctx[:users] = @users
    end
  end

  class Assignment < Trailblazer::Operation
    step :request_from?, Output(:success) => Track(:data_for_web),
                         Output(:failure) => Id(:data_for_mobile)

    step :fiter_user_with_time, Output(:success) => Track(:data_for_web), magnetic_to: :data_for_web
    step :fiter_user_with_status, Output(:success) => Track(:data_for_web), magnetic_to: :data_for_web
    step :data_for_mobile
    fail :send_errors

    def request_from?(ctx, params:, **)
      params[:request_from] == "web"
    end

    def fiter_user_with_time(ctx, params:, **)
      ctx[:users] = User.where('created_at >= ? and created_at <= ?', params[:from_date], params[:to_date])
    end

    def fiter_user_with_status(ctx, params:, users:, **)
      ctx[:users] = users.where(status: params[:status])
      ctx[:users].present?
    end

    def data_for_mobile(ctx, **)
      ctx[:users] = User.order(created_at: :desc)
    end

    def send_errors(ctx, **)
      ctx[:errors] = {error: "Someting Went Wrong"}
    end
  end
end