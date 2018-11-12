module Hanami
  module Webpack
    module SecurityHeadersHijack
      def content_security_policy(*args)
        #hack, because we can't load before hanami cli
        #more: https://github.com/hanami/hanami/issues/960
        Webpack.load_app_config

        new_script_src_directive = "script-src 'self' 'unsafe-eval'"

        if Hanami::Webpack.config.use_dev_server?
          new_script_src_directive +=
            " http://#{Hanami::Webpack.config.dev_server.host}:#{Hanami::Webpack.config.dev_server.port}"
        end

        super(*args).gsub("script-src 'self'", new_script_src_directive)
      end
    end
  end
end
