class BootstrapController < ApplicationController
  def form
    @collection = [
      Address.new(id: 1, street: "Foo"),
      Address.new(id: 2, street: "Bar")
    ]

    @user = User.new

    @user_with_error = User.new
    @user_with_error.errors.add(:email)
    @user_with_error.errors.add(:misc)
  end

  def static_control
    @collection = [
      Address.new(id: 1, street: "Foo"),
      Address.new(id: 2, street: "Bar")
    ]

    @user = User.new

    @user_with_error = User.new
    @user_with_error.errors.add(:email)
    @user_with_error.errors.add(:misc)
  end

  def create
    redirect_to "/bootstrap/static_control"
  end
end
