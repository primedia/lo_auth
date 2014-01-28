  # LoAuth OAuth2-compatibility routes below:
  get "lo_auth/implicit", to: "lo_auth#implicit_grant", as: "implicit_grant"
  get "lo_auth/auth_code", to: "lo_auth#auth_code", as: "auth_code"
  get "lo_auth/request_token", to: "lo_auth#request_token", as: "request_token"
  get "lo_auth/token_info", to: "lo_auth#token_info", as: "token_info"
