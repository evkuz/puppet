source "https://rubygems.org"

gem 'rspec', '~> 3.1.0'
gem 'rake', '< 11.0'
gem 'puppetlabs_spec_helper'
gem 'puppet-blacksmith'
gem 'metadata-json-lint'

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion,  :require => false
else
  gem 'puppet',                 :require => false
end
