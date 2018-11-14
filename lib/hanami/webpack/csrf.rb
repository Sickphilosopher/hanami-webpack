module Hanami
  module Webpack
    module CSRF
      def self.dev_server_csrf
        address = "#{Hanami::Webpack.config.dev_server.host}:#{Hanami::Webpack.config.dev_server.port}"
        {
          'script-src': %W(http://#{address}),
          'connect-src': %W(http://#{address} ws://#{address}),
          'img-src': %W(http://#{address}),
          'font-src': %W(http://#{address})
        }
      end
    end
  end
end
