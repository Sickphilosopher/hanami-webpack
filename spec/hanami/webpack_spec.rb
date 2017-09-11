require "spec_helper"

RSpec.describe Hanami::Webpack do
  it "has a version number" do
    expect(Hanami::Webpack::VERSION).not_to be nil
  end

  context ".config" do
    before(:all) do
      Hanami::Webpack.define_singleton_method :reset_config do
        remove_instance_variable :@_config if defined? @_config
      end
    end

    before(:each) do
      Hanami::Webpack.reset_config
    end

    it "sets dev_server.using? to true in development env" do
      allow(Hanami).to receive(:env).and_return("development")
      expect(Hanami::Webpack.config.dev_server.using?).to be true
    end

    it "sets dev_server.using? to false if env != development" do
      allow(Hanami).to receive(:env).and_return("production")
      expect(Hanami::Webpack.config.dev_server.using?).to be false
    end
  end
end
