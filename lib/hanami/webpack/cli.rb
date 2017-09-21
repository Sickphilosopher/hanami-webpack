require 'thor'

require 'hanami/cli_base'
require 'hanami/webpack/commands/build'
require 'hanami/webpack/commands/dev_server'

module Hanami
  module Webpack
    class Cli < Thor
      extend CliBase

      desc 'version', 'Prints hanami-webpack version'
      def version
        require 'hanami/webpack/version'
        puts "v#{Hanami::Webpack::VERSION}"
      end
      map %w{--version -v} => :version

      desc 'build', 'Build Webpack bundles'
      def build
        Hanami::Webpack::Commands::Build.new(options).start
      end

      desc 'dev-server', 'Start Webpack development server'
      def dev_server
        Hanami::Webpack::Commands::DevServer.new(options).start
      end
    end
  end
end