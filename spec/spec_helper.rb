require 'loc_counter'

support_dir = File.expand_path('../support', __FILE__)
Dir.glob("#{support_dir}/**/*.rb").each { |file| require file }

RSpec.configure do |config|
  config.include FilesCollectionHelpers
end
