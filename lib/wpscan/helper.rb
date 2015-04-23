def read_json_file(file)
  content = File.open(file).read

  begin
    JSON.parse(content)
  rescue => e
    puts "[ERROR] In JSON file parsing #{file} #{e}"
    raise
  end
end
