module LoAuth
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def run_stuff
        # copy controller
        copy_file "lo_auth_controller.rb", "app/controllers/lo_auth_controller.rb"

        # copy routes
        routes = File.read(find_in_source_paths("routes.rb"))
        inject_into_file 'config/routes.rb', routes, after: "draw do\n"

        # copy token/code/client models
        copy_file "access_token.rb", "app/models/lo_auth/access_token.rb"
        copy_file "authorization_code.rb", "app/models/lo_auth/authorization_code.rb"
        copy_file "registered_client.rb", "app/models/lo_auth/registered_client.rb"

        # copy autoload paths
        autoload_paths = File.read(find_in_source_paths("autoload_paths.rb"))
        inject_into_file 'config/application.rb', autoload_paths, after: "< Rails::Application\n"
      end
    end
  end
end
