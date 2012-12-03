# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jquery-bootstrap-pagination/version'

Gem::Specification.new do |gem|
  gem.name          = "jquery-bootstrap-pagination"
  gem.version       = Jquery::Bootstrap::Pagination::VERSION
  gem.authors       = ["Mark Bates"]
  gem.email         = ["mark@markbates.com"]
  gem.description   = %q{A simple and clean pagination implementation for jQuery and Twitter Bootstrap.}
  gem.summary       = %q{A simple and clean pagination implementation for jQuery and Twitter Bootstrap.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
