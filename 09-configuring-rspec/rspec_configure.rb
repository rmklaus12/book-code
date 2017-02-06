# validate me
require 'rspec/core'
require 'stringio'
require 'fuubar'

$spec_out = StringIO.new
$spec_err = StringIO.new
RSpec.configuration.output_stream = $spec_out
RSpec.configuration.error_stream  = $spec_err

class MyFormatter; end
class AveragePerson; end
class SwissArmyKnife; end
module Singing; end
module Dancing; end
module ExtraExampleMethods; end
module ImportantExampleMethods; end
module ExtraGroupMethods; end

RSpec.configure do |config|
  config.add_formatter MyFormatter
end

RSpec.configure do |config|
  config.before(:example) do
    # ...
  end
end

RSpec.configure do |config|
  config.when_first_matching_example_defined(:db) do
    require 'support/db'
  end
end

class Performer
  include Singing # won't override Performer methods
  prepend Dancing # may override Performer methods
end

average_person = AveragePerson.new
average_person.extend Singing

RSpec.configure do |config|
  # Brings methods into each example
  config.include ExtraExampleMethods

  # Brings methods into each example,
  # overriding methods with the same name
  # (rarely used)
  config.prepend ImportantExampleMethods

  # Brings methods into each group (alongside let/describe/etc.)
  # Useful for adding to RSpec's domain-specific language
  config.extend ExtraGroupMethods
end

RSpec.shared_context 'My Shared Group' do
end

RSpec.configure do |config|
  config.include_context 'My Shared Group'
end

RSpec.configure do |config|
  # You can use the same formatter names supported by the CLI...
  config.add_formatter 'documentation'

  # ...or pass _any_ formatter class, including a custom one:
  config.add_formatter Fuubar
end

RSpec.configure do |config|
  config.add_formatter 'documentation', $stdout
  config.add_formatter 'html', 'specs.html'
end

RSpec.configure do |config|
  config.default_formatter = config.files_to_run.one? ? 'doc' : 'progress'
end

# Old syntax

describe SwissArmyKnife do  # bare `describe` method
  it 'is useful' do
    knife.should be_useful  # `should` expectation
  end
end

RSpec.configure do |config|
  config.disable_monkey_patching!
end

# New syntax

RSpec.describe SwissArmyKnife do  # `RSpec.describe` called via module
  it 'is useful' do
    expect(knife).to be_useful    # `expect()`-style expectation
  end
end

RSpec.configure do |config|
  config.order = :random
end

RSpec.configure do |config|
  config.add_setting :too_slow_threshold, default: 1
end

RSpec.configure do |config|
  config.too_slow_threshold = 2
end
