# -*- encoding: utf-8 -*-
require File.expand_path('../lib/business_days/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Robert Jackson"]
  gem.email         = ["robertj@promedicalinc.com"]
  gem.description   = %q{Calculate the number of business days in a given period.  Also, add convenience methods to Range, Date, and Time.}
  gem.summary       = %q{Simple business day calculations.}
  gem.homepage      = "https://github.com/rjackson/business_days"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "business_days"
  gem.require_paths = ["lib"]
  gem.version       = BusinessDays::VERSION
end
