module Hanami
  module Webpack
    module SecurityHeadersHijack
      def content_security_policy(*args)
        new_script_src_directive = "script-src 'self' 'unsafe-eval'"

        if Hanami::Webpack.config.dev_server.using
          new_script_src_directive +=
            " http://#{Hanami::Webpack.config.dev_server.host}:#{Hanami::Webpack.config.dev_server.port}"
        end

        super(*args).gsub("script-src 'self'", new_script_src_directive)
      end
    end
  end
end
