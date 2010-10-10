#####
# Bootstrap the Rails environment, frameworks, and default configuration
####

# Make sure we are using the latest rexml
rexml_versions = ['', File.join(File.dirname(__FILE__), '..', 'vendor', 'plugins', 'rexml', 'lib', '')].collect { |v| 
  `ruby -r "#{v + 'rexml/rexml'}" -e 'p REXML::VERSION'`.split('.').collect {|n| n.to_i} }
$:.unshift(File.join(File.dirname(__FILE__), '..', 'vendor', 'plugins', 'rexml', 'lib')) if (rexml_versions[0] <=> rexml_versions[1]) == -1

require File.join(File.dirname(__FILE__), 'boot')

require 'active_support/secure_random'

Rails::Initializer.run do |config|

  # Secret session key
  #   The secret session key is automatically generated, and stored
  #   in a hash. It is typed in this file, so it is not secure and should vary
  #   from installation to installation. This is a limitation of Heroku, not of
  #   Rails.

  config.action_controller.session = { 
    :session_key => "instiki_session",
    :secret => 413b360b05de6b16dcb19caa9eedf6fbe32ddbec43616b949f574686db96c6c4
   } 

  # Don't do file system STAT calls to check to see if the templates have changed.
  #config.action_view.cache_template_loading = true

  # Skip frameworks you're not going to use
  config.frameworks -= [ :action_web_service, :action_mailer ]

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake create_sessions_table')
  #config.action_controller.session_store = :active_record_store

  # Enable page/fragment caching by setting a file-based store
  # (remember to create the caching directory and make it readable to the application)
  config.cache_store = :file_store, "#{RAILS_ROOT}/cache"

  # Activate observers that should always be running
  config.active_record.observers = :page_observer

  # Use Active Record's schema dumper instead of SQL when creating the test database
  # (enables use of different database adapters for development and test environments)
  config.active_record.schema_format = :sql

  File.umask(0026)
end

# Instiki-specific configuration below
require_dependency 'instiki_errors'

#require 'jcode'
require 'caching_stuff'
require 'logging_stuff'

#Additional Mime-types 
mime_types = YAML.load_file(File.join(File.dirname(__FILE__), 'mime_types.yml'))
Rack::Mime::MIME_TYPES.merge!(mime_types)
