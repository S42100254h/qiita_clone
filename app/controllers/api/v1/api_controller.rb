class Api::V1::ApiController < ApplicationController
  def current_user
    current_user = User.first
  end
end
