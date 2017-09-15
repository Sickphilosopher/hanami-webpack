require 'net/http'
require 'hanami/utils/blank'
require 'hanami/utils/path_prefix'
require_relative 'errors/manifest_not_found_error'
require_relative 'errors/entry_point_missing_error'

module Hanami
  module Webpack
    class Manifest
      def self.bundle_uri(bundle_name)

        #raise Webpack::Errors::BuildError, manifest['errors'] unless Utils::Blank.blank?(manifest['errors'])

        bundle = manifest.fetch(bundle_name) do
          raise Webpack::EntryPointMissingError, "Can't find entry point '#{bundle_name}' in webpack manifest"
        end

        js_path = bundle.fetch('js')

        if Webpack.config.dev_server.using?
          path = "#{dev_server_path}#{Utils::PathPrefix.new('/').join(js_path)}"
        else
          path = Utils::PathPrefix.new('/').join(Webpack.config.public_path).join(js_path).to_s
        end

        path
      end

      def self.static_manifest
        File.read(static_manifest_path)
      rescue Errno::ENOENT => e
        raise Webpack::Errors::ManifestNotFoundError.new(static_manifest_path)
      end

      def self.manifest
        @_manifest = nil unless Webpack.config.cache_manifest?
        @_manifest ||= Hanami::Utils::Json.parse(static_manifest)
      end

      def self.static_manifest_path
        Hanami.root.join(Webpack.config.manifest.dir, Webpack.config.manifest.filename)
      end

      def self.dev_server_path
        "//#{Webpack.config.dev_server.host}:#{Webpack.config.dev_server.port}"
      end
    end
  end
end
