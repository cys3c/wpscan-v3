require 'dm-core'
require 'dm-migrations'
require 'dm-constraints'
require 'dm-sqlite-adapter'

require 'wpscan/db/schema'
require 'wpscan/db/updater'
require 'wpscan/db/plugins'
require 'wpscan/db/wp_version'
require 'wpscan/db/wp_item'
require 'wpscan/db/plugin'
require 'wpscan/db/theme'
require 'wpscan/db/themes'

module WPScan
  # DB
  module DB
    def self.init_db
      db_file ||= File.join(DB_DIR, 'wordpress.db')

      # DataMapper::Logger.new($stdout, :debug)
      DataMapper.setup(:default, "sqlite://#{db_file}")
      DataMapper.auto_upgrade!
    end
  end
end
