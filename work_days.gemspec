# -*- encoding: utf-8 -*-
require File.expand_path('../lib/work_days/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Robert Jackson"]
  gem.email         = ["robert.w.jackson@me.com"]
  gem.description   = %q{Calculate the number of work days in a given period.  Also, add convenience methods to Range, Date, DateTime, and Time.}
  gem.summary       = %q{Simple business day calculations.}
  gem.homepage      = "https://github.com/rjackson/work_days"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "work_days"
  gem.require_paths = ["lib"]
  gem.version       = WorkDays::VERSION

  gem.add_dependency 'thor', '~> 0.18.0'
  gem.add_development_dependency 'rspec', '~> 2.14.0'
end
