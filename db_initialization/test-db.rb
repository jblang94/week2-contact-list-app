Base.connection
results = Base.connection.exec('SELECT * FROM contacts;')
results.each do |result|
  result.each do |contact|
    p contact
    puts "\n\n"
  end
end
