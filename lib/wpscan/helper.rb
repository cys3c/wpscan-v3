def read_json_file(file)
  # p "Reading #{file}"
  JSON.parse(File.read(file))
rescue => e
  raise "JSON parsing error in #{file} #{e}"
end
