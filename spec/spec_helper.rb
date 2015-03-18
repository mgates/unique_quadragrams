Dir[File.expand_path('../../lib/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |c|
  c.filter_run_excluding :benchmark
end

