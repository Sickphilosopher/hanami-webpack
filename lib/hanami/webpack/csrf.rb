module Hanami
  module Webpack
    module CSRF
      def self.dev_server_csrf
        scheme = Hanami::Webpack.config.dev_server.https ? 'https' : 'http'
        addresses = Hanami::Webpack.config.dev_server.ports.map do |app, port|
          "#{Hanami::Webpack.config.dev_server.host}:#{port}"
        end

        {
          'script-src': addresses.map { |address| "#{scheme}://#{address}" },
          'connect-src': addresses.map { |address| %W(#{scheme}://#{address} ws://#{address} wss://#{address})}.flatten,
          'img-src': addresses.map { |address| "#{scheme}://#{address}" },
          'font-src': addresses.map { |address| "#{scheme}://#{address}" }
        }
      end
    end
  end
end
