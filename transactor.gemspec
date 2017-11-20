# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__), 'lib', 'transactor', 'version.rb'])
Gem::Specification.new do |s|
  s.name = 'transactor'
  s.version = Transactor::VERSION
  s.author = 'Pavan Prakash'
  s.email = 'pavanprakash21@gmail.com'
  s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Rival Corp is a next generation banking company.'
  s.files = `git ls-files`.split('
')
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc', 'transactor.rdoc']
  s.rdoc_options << '--title' << 'transactor' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'transactor'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_development_dependency('pry')
  s.add_runtime_dependency('gli', '2.17.1')
end
