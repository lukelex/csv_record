# -*- encoding: utf-8 -*-
require File.expand_path('../lib/csv_record/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Lukas Alexandre"]
  gem.email         = ["lukasalexandre@gmail.com"]
  gem.description   = %q{CSV Object-relational mapping for Ruby}
  gem.summary       = %q{CSV Record connects Ruby classes to CSV documents database to establish an almost zero-configuration persistence layer for applications.}
  gem.homepage      = "https://github.com/lukelex/csv_record"

  gem.license = 'MIT'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "csv_record"
  gem.require_paths = ["lib"]
  gem.version       = CsvRecord::VERSION

  gem.add_dependency 'activesupport'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'timecop'
  gem.add_development_dependency 'turn'
  gem.add_development_dependency 'minitest'
end
