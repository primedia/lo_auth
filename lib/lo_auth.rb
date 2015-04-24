module LoAuth
  module Controller
    def redirect_uri_with_token(token)
      out = {
        access_token: token,
        token_type: "bearer",
        # expires_in: ...,
        # scope: ...,
        state: token.clear_and_return_state
      }

      params[:redirect_uri] + "#" + URI.encode_www_form(out)
    end

    def redirect_uri_with_code(code)
      out = { code: code }
      params[:redirect_uri] + "?" + URI.encode_www_form(out)
    end

    private

    def complete_login(params)
      if params[:response_type] == "token"
        implicit_grant_redirect(params)
      else
        auth_code_redirect(params)
      end
    end

    def implicit_grant_redirect(params, token_class=::AccessToken)
      redirect_to redirect_uri_with_token(token_class.create(params))
    end

    def auth_code_redirect(params, code_class=::AuthorizationCode)
      redirect_to redirect_uri_with_code(code_class.create(params.merge(client_class: RegisteredClient)))
    end
  end

  module AccessToken
    attr_reader :level

    def to_s
      @token.to_s
    end

    def token_info
      {
        scope: "",
        audience: ""
        # etc...
      }
    end

    def params_clone
      @params.clone
    end

    def clear_and_return_state
      state = @state ? @state.clone : nil
      @state = nil
      state
    end

    def initialize(opts)
      make_token(opts)
    end

    private

    def make_token(params)
      @token = generate_token(params)
      @level = 1
      @state = params.delete(:state)
      @params = params
    end
  end

  module AuthorizationCode
    attr_reader :level

    def to_s
      @code.to_s
    end

    def exchange_for_token(token_class, client_id, client_secret)
      verified_client = verify_client(client_id, client_secret)

      if verified_client && (@client == verified_client)
        self.destroy
        token_class.create(@params)
      end
    end

    def initialize(opts)
      make_code(opts)
    end

    def verify_client(client_id, client_secret)
      if client_id && client_secret
        @client_class.verify(client_id, client_secret)
      end
    end

    private

    def make_code(params)
      @client_class = params.delete(:client_class)

      if client_id = verify_client(params.delete(:client_id), params.delete(:client_secret))
        @code = generate_code(params)
        @level = 2
        @client = client_id
        @params = params
      end
    end
  end

  module RegisteredClient
    module ClassMethods
      def verify(client_id, client_secret)
        if client_id && client_secret
          if c = self.find(client_id)
            if c.verify(client_secret)
              c.to_s
            end
          end
        end
      end
    end

    def self.included(base)
      base.send :extend, LoAuth::RegisteredClient::ClassMethods
    end

    def initialize(params)
      @client_id = params[:client_id]
      @client_secret = params[:client_secret]
    end

    def verify(secret)
      @client_secret == secret
    end

    def to_s
      @client_id.to_s
    end
  end

  module ActiveRecord
    def attributes_for_token(token)
      if token.level == 3
        attributes_level_3(token.params_clone)
      elsif token.level == 2
        attributes_level_2(token.params_clone)
      elsif token.level == 1
        attributes_level_1(token.params_clone)
      end
    end

    def attributes_level_3(params={})
      attributes
    end

    def attributes_level_2(params={})
      attributes
    end

    def attributes_level_1(params={})
      attributes
    end

    # assumes that the behavior should be if you can't view info,
    # you can't update it, and if you can view it, you can update
    # it. 
    # TODO: ability to customize that.
    def update_attributes_with_token(token, params)
      params.keys.each do |key|
        if attributes_for_token(token).keys.include?(key) == false
          errors.add(:base, "can't update") # need better msg
          return
        end
      end

      update_attributes(params)
    end
  end

  module MemStore
    module ClassMethods
      def items
        @@items ||= {}
      end

      def find(item)
        _, item = items.find { |k,v| v.to_s == item }
        item
      end

      def create(opts)
        new(opts).save
      end
    end

    def self.included(base)
      base.send :extend, LoAuth::MemStore::ClassMethods
    end

    def initialize(opts)
      super
      @opts = opts
    end

    def save
      key = @opts.hash
      self.class.items[key] = self
    end

    def destroy
      key = @opts.hash
      self.class.items.delete(key)
    end
  end
end
