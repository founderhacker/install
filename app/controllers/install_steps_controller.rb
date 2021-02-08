class InstallStepsController < ApplicationController
  include Wicked::Wizard

  prepend_before_action :set_steps
  after_action :set_session

  rescue_from Wicked::Wizard::InvalidStepError, with: ->{ redirect_to root_path }

  def show
    case step
    when :update_ruby
      skip_step if ruby_version =~ /2/
    when :update_rails
      skip_step if rails_version =~ /5/
    end
    render_wizard
  end

  def update
    current_user.update(user_params)
    render_wizard current_user
  end

  private

  def set_steps
    self.steps = [:choose_os]
    case
    when mac?
      self.steps += mac_steps
    when windows?
      self.steps += windows_steps
    when linux?
      self.steps += ubuntu_steps
    end
  end

  def mac_steps
    steps = [:choose_os_version]
    case os_version
    when "11.1+"
      steps += [
        :install_xcode,
        :find_the_command_line,
        :change_zsh_to_bash,
        :install_homebrew,
        :install_git,
        :configure_git,
        :install_rbenv_and_ruby,
        :install_rails,
        :text_editor,
        # :create_your_first_app,
        # :see_it_live
      ]
    when "10.15", "10.14", "10.13", "10.12", "10.11", "10.10", "10.9"
      steps += [
        :install_xcode,
        :find_the_command_line,
        :install_homebrew,
        :install_git,
        :configure_git,
        :install_rbenv_and_ruby,
        :install_rails,
        :text_editor,
        # :create_your_first_app,
        # :see_it_live
      ]
    end
    return steps
  end

  def windows_steps
    # onemonth.com version
    # [
    #   :railsinstaller_windows,
    #   :find_git_bash,
    #   :update_rubygems,
    #   :update_rails,
    #   :text_editor,
    #   # :create_your_first_app,
    #   # :see_it_live
    # ]

    [
      :text_editor,
      :ubuntu,
      :ruby_rbenv_windows,
      :git_windows,
      :rails_windows,
      :postgres_windows,
      :test_app_windows # use "create_your_first_app" or "see_it_live" file?
    ]
  end

  def ubuntu_steps
    [:rails_for_linux_and_other]
  end

  def finish_wizard_path
    congratulations_path
  end

  def user_params
    params.permit(:os, :os_version, :ruby_version, :rails_version)
  end

  def set_session
    session[:user] = current_user.config
  end
end
