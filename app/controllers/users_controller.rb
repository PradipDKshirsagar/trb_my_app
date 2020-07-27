class UsersController < ApplicationController
  def index
    result = User::Operation::Index.(params: params)
    response = if result[:error].present?
      result[:error]
    else
      result[:users]
    end
    render json: response
  end

  def show 
    result = User::Operation::Show.(params: params)
    response = if result[:error].present?
      result[:error]
    else
      result[:user]
    end
    render json: response
  end
end
