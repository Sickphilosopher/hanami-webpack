module Hanami
  module Webpack
    module CSRF
      def self.dev_server_csrf
        scheme = Hanami::Webpack.config.dev_server.https ? 'https' : 'http'
        address = "#{Hanami::Webpack.config.dev_server.host}:#{Hanami::Webpack.config.dev_server.port}"
        {
          'script-src': %W(#{scheme}://#{address}),
          'connect-src': %W(#{scheme}://#{address} wss://#{address}),
          'img-src': %W(#{scheme}://#{address}),
          'font-src': %W(#{scheme}://#{address})
        }
      end
    end
  end
end
