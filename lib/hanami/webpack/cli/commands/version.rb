require "hanami/cli/commands"

module Hanami
  module Webpack
    module Cli
      module Commands
        class Version < Hanami::CLI::Commands::Command
          desc 'Prints hanami-webpack version'
          def call(*)
            require 'hanami/webpack/version'
            puts "v#{Hanami::Webpack::VERSION}"
          end
        end
      end
    end
  end
end

Hanami::CLI.register "webpack version", Hanami::Webpack::Cli::Commands::Version