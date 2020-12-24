require 'bundler/setup'
require 'typed_params'

# load shared_contexts
Dir["#{__dir__}/supports/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  true
end

TypedParams.configure do |config|
  config.sig_path = "#{__dir__}/support/sig"
end
