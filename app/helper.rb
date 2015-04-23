# @return [ Hash ]
def dynamic_finders_config
  YAML.load_file(File.join(WPScan::DB_DIR, 'dynamic_finders.yml'))
end
