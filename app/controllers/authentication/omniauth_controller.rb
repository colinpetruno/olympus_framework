module Authentication
  class OmniauthController < ApplicationController
    PROCESSORS = {
      login: Authentication::Processors::Login,
      connect: Authentication::Processors::ConnectToCompany,
      ask_for_invite: Authentication::Processors::AskForInvite,
      create_account: Authentication::Processors::AccountCreator,
      add_provider: Authentication::Processors::AddProvider
    }.freeze

    def create
      oauth_response = ::Authentication::OauthResponse.new(
        request.env["omniauth.auth"],
        session_info
      )

      action = ::Authentication::Action.for(oauth_response)

      if PROCESSORS[action.action_name.to_sym].present?
        PROCESSORS[action.action_name.to_sym].for(oauth_response)
      end

      if [:ask_for_invite, :connect, :login, :create_account].include?(action.action_name)
        sign_in(action.member)
      end

      redirect_to action.redirect_path
    end
  end
end
