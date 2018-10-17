require_relative 'commands/version'
require_relative 'commands/build'
require_relative 'commands/server'

module Hanami
  module Webpack
    module Cli
      module Commands
        Hanami::CLI.register 'webpack', aliases: %w(wp) do |prefix|
          prefix.register 'build', Build, aliases: %w(b)
          prefix.register 'server', Server, aliases: %w(s)
          prefix.register 'version', Version, aliases: %w(v -v --version)
        end
      end
    end
  end
end
