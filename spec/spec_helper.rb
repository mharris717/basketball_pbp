$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'basketball_pbp'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end

def parse_play(line)
  return :standin if line =~ /jump ball/i or line =~ /(substitution|technical|timeout|ejection)/i or line =~ /end of/i or line =~ /illegal screen/i
  PbpFullParser.new.parse(line.downcase)
end