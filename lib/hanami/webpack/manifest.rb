require 'net/http'
require 'hanami/utils/blank'
require 'hanami/utils/path_prefix'
require_relative 'errors/build_error'
require_relative 'errors/entry_point_missing_error'

module Hanami
  module Webpack
    class Manifest
      def self.bundle_uri(bundle_name)

        raise Webpack::Errors::BuildError, manifest['errors'] unless Utils::Blank.blank?(manifest['errors'])

        path = manifest.fetch('assetsByChunkName').fetch(bundle_name) do
          raise Webpack::EntryPointMissingError, "Can't find entry point '#{bundle_name}' in webpack manifest"
        end

        

        if Webpack.config.dev_server.using?
          path = Utils::PathPrefix.new('/').join(path).to_s
          path = "//#{Webpack.config.dev_server.host}:#{Webpack.config.dev_server.port}#{path}"
        else
          path = Utils::PathPrefix.new('/').join(Webpack.config.public_path).join(path).to_s
        end

        path
      end

      def self.manifest_path
        Utils::PathPrefix.new('/').join(Webpack.config.public_path).join(Webpack.config.manifest_file)
      end

      def self.remote_manifest
        host = Webpack.config.dev_server.host
        port = Webpack.config.dev_server.port
        http = Net::HTTP.new(host, port)
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        manifest_path = Utils::PathPrefix.new('/').join(Webpack.config.manifest_file)
        response = http.get(manifest_path).body
        response
      end

      def self.static_manifest
        @_manifest ||= begin
          path =
            Hanami
              .public_directory
              .join(*Webpack.config.public_path.split('/'))
              .join(Webpack.config.manifest_file)

          file = File.read(path)
          file
        end
      end

      def self.manifest
        manifest_src = Webpack.config.dev_server.using? ? remote_manifest : static_manifest
        JSON.parse(manifest_src)
      end
    end
  end
end
