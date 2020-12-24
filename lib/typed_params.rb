require 'typed_params/analyzer'
require 'typed_params/config'
require 'typed_params/environment'

module TypedParams
  class InvalidTypeError < StandardError; end

  def typed_params(parameters, type)
    diff = TypedParams::Analyzer.diff(parameters, type)
    return parameters if diff.nil?
    raise TypedParams::InvalidTypeError.new(diff.inspect)
  end

  def self.configure
    yield config
  end

  def self.config
    @_config ||= TypedParams::Config.new
  end
end
