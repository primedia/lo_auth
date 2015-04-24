require 'lo_auth'

# Actions for OAuth2 compatibility. This is a very basic implementation
# with no error handling. Developers should add error handling that is
# appropriate for their application.
class LoAuthController < ApplicationController

  # provides: #redirect_uri_with_token, #redirect_uri_with_code
  include LoAuth::Controller

  # After user successfully logs in & establishes a session in your app,
  # pass the user here with the redirect_uri to create a new 
  # AuthorizationCode which they can then exchange later for an AccessToken.
  def auth_code
    redirect_to redirect_uri_with_code(AuthorizationCode.create(params.merge(client_class: RegisteredClient)))
  end

  # Calling this action will destroy the current AuthorizationCode and
  # create a new AccessToken which the consumer can then use to access
  # protected resources.
  def request_token
    render :text => AuthorizationCode.find(params[:code]).exchange_for_token
  end

  # This returns a JSON of information about a token useful for client-
  # side token validation.
  # (see: https://developers.google.com/accounts/docs/OAuth2UserAgent)
  def token_info
    render :text => AccessToken.find(params[:token]).token_info.to_json
  end
end
