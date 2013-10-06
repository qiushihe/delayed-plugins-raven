lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'delayed-plugins-raven/version'

Gem::Specification.new do |gem|
  gem.name          = "delayed-plugins-raven"
  gem.version       = Delayed::Plugins::Raven::VERSION
  gem.authors       = ['Qiushi He', 'Benjamin Oakes', 'Bruno Miranda']
  gem.email         = ['qiushihe@me.com']
  gem.description   = %q(delayed_job exception notification with raven)
  gem.summary       = %q(Notify Sentry Raven on Delayed Job errors, including those on PerformableMethod. Based on Ben Oakes's AirBrake plugin (https://github.com/benjaminoakes/delayed-plugins-airbrake) with samples provided by Bruno Miranda (https://gist.github.com/brupm/3c7056b03d62ba415015).)
  gem.homepage      = "https://github.com/qiushihe/delayed-plugins-raven"
  gem.license       = "Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('sentry-raven')
  gem.add_dependency('delayed_job')

  gem.add_development_dependency('rake')
  gem.add_development_dependency('rspec')
end
