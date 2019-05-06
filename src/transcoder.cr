p = Process.new("./hb.sh", args: ["1"])
p.wait()

puts "done"
