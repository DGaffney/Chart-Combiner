files = `ls`.split("\n").collect{|f| f if f.include?(".csv")}.compact
synthesized_file = {}
files.each do |file|
  f = File.open(file)
  chart = f.read
  f.close
  dataset = chart.split("\n").collect{|line| line.split(",")}
  dataset.shift
  dataset.each do |k,v|
    if synthesized_file[k].nil?
      synthesized_file[k] = {}
      synthesized_file[k][file] = v.gsub("\"", "").to_i
      synthesized_file[k]["total"] = v.gsub("\"", "").to_i
      synthesized_file[k]["time"] = k
    else
      synthesized_file[k][file] = v.gsub("\"", "").to_i
      synthesized_file[k]["total"] += v.gsub("\"", "").to_i
    end
  end
end
csv = ""
first = true
synthesized_file.values.each do |value|
  if first
    csv+="time,#{files.collect{|tmp_f| tmp_f.gsub(".csv", "")}.join(",")},total\n"
  end
  time = value["time"]
  total = "\"#{value["total"]}\""
  files.each do |file|
    value[file] = value[file].nil? ? "\"0\"" : "\"#{value[file]}\""
  end
  csv+= time+","+files.collect{|file| value[file]}.join(",")+","+total+"\n"
  first = false
end
f = File.open("synthesized_output.csv", "w+")
f.write(csv)
f.close