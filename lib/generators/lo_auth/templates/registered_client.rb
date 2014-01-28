require 'lo_auth'

class RegisteredClient
  include LoAuth::RegisteredClient
  include LoAuth::MemStore
end
