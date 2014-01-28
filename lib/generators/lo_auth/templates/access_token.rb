require 'lo_auth'
require 'securerandom'

# AccessToken class must expose a #to_s method which returns the actual
# token string. The AccessToken.find(...) method must accept the
# result of #to_s as an argument and return the original AccessToken
# object. It must also expose an AccessToken.create(...) method which
# generates and stores a new token string, along with any other information
# associated with the token.
class AccessToken

  # provides: to_s, initialize
  include LoAuth::AccessToken

  # LoAuth::MemStore provides an in-memory storage system for authorization codes
  # and access tokens. It does not persist through server restarts. You can
  # enable DB persistence by subclassing ActiveRecord::Base:
  #
  # class AccessToken < ActiveRecord::Base
  #
  # ...and removing the following include:
  include LoAuth::MemStore

  # LoAuth::AccessToken calls generate_token in order to build the token string.
  # Below is a simple implementation which returns a random string.
  def generate_token(params)
    SecureRandom.uuid
  end
end
