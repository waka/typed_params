require './typed_params/analyzer'
require './typed_params/environment'

module TypedParams
  class InvalidTypeError < StandardError; end

  def typed_params(params, type)
    return params if Analyzer.check_type(params, type)
    raise InvalidTypeError
  end
end
