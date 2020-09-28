require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(
	adapter: 'sqlite3',
	database: 'db/development.db'
)
# turns off SQL logger, added by project devs
ActiveRecord::Base.logger = nil
# alternative: ActiveRecord::Base.logger = Logger.new(STDOUT)

require_all 'lib'
# everything required below added by project devs, everything above from project template
require_all 'app'
require 'pry'
require 'json'
require 'rest-client'
# require 'tty-prompt'
# require 'tty-font'
# require 'awesome_print'