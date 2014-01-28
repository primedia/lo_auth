require 'lo_auth'
require 'securerandom'

# AuthorizationCode class must expose a #to_s method which returns the actual
# auth code string. The AuthorizationCode.find(...) method must accept the
# result of #to_s as an argument and return the original AuthorizationCode
# object. It must also expose an AuthorizationCode.create(...) method which
# generates and stores a new code string, along with any other information
# associated with the code. It must also expose #exchange_for_token, which
# destroys the AuthorizationCode and returns a new AccessToken with the same
# parameters
class AuthorizationCode

  # provides: to_s, initialize, exchange_for_token
  include LoAuth::AuthorizationCode

  # LoAuth::MemStore provides an in-memory storage system for AuthorizationCode
  # codes and access tokens. It does not persist through server restarts. You 
  # can enable DB persistence by subclassing ActiveRecord::Base:
  #
  # class AuthorizationCode < ActiveRecord::Base
  #
  # ...and removing the following include:
  include LoAuth::MemStore

  # LoAuth::AuthorizationCode calls generate_token in order to build the
  # token string. Below is a simple implementation which returns a random
  # string.
  def generate_code(params)
    SecureRandom.uuid
  end
end
