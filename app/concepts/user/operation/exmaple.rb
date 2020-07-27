module User::Operation
 
  class ExampleOne < Trailblazer::Operation
    step :first_step
    step :second_step
    pass :first_pass
    fail :first_fail
    step :third_step
    fail :second_fail
    pass :second_pass

    def first_step(ctx, **)
      p 'In first step'
      true
    end

    def first_pass(ctx, **)
      p 'in first pass'
      false
    end

    def second_pass(ctx, **)
      p 'in second pass'
      true
    end

    def second_step(ctx, **)
      p 'In second step'
      false
    end

    def first_fail(ctx, **)
      p 'In first fail'
    end

    def third_step(ctx, **)
      p 'In third step'
      true
    end

    def second_fail(ctx, **)
      p 'In second fail'
    end
  end

  class ExampleTwo < Trailblazer::Operation
    step :valid_request?

    step :load_data, Output(:success) => Track(:suraj)

    step :filter_data, Output(:success) => Track(:suraj),
                       magnetic_to: :suraj
    fail :log_errors

    step :suraj_success_message, magnetic_to: :suraj

    def valid_request?(ctx, **)
      true
    end

    def load_data(ctx, **)
      ctx[:users] = User.all
    end

    def filter_data(ctx, **)
      puts 'Inside filter data'
      true
    end

    def log_errors(ctx, **)
      ctx[:errors] = 'Invalid request'
    end

    def suraj_success_message(ctx, **)
      puts 'Inside custom track'
      true
    end
  end

  class ExampleThree < Trailblazer::Operation
    step :create_user
    step :address_present?, Output(:failure) => Id(:send_mail)
    step :create_address
    step :send_mail
    step :custom_suraj
    fail :address_error

    def create_user(ctx, params:, **)
      ctx[:user] = User.create(params[:user])
    end

    def custom_suraj(ctx, **)
      puts "in customer suraj"
      return true
    end

    def address_present?(ctx, params:, **)
      params[:address].present?
    end

    def create_address(ctx, params:, user:, **)
      user.create_address(params[:address])
    end

    def send_mail(ctx, **)
      puts 'Sent mail'
      true
    end
  end

end