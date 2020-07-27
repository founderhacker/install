class MainController < ApplicationController
  def congratulations
    render layout: "install_steps"
  end
end
