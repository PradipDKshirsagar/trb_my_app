module User::Operation
  class Show < Trailblazer::Operation

    step :fetch_users
    fail :set_error_message
    step :set_success_object

    def fetch_users(ctx, params:, **)
      @user = User.find_by(id: params[:id])
    end

    def set_error_message(ctx, **)
      ctx[:error] = { error: "Record not present" }
    end

    def set_success_object(ctx, **)
      ctx[:user] = @user
    end

  end
end