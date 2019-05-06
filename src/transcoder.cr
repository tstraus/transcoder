require "kemal"

module TRANSCODER
    get "/" do |env|
        env.redirect "index.html"
    end

    post "/encode" do |env|
        puts env.params.json
    end

    p = Process.new("./hb.sh", args: ["1"])
    p.wait()
    
    puts "done"

    Kemal.run
end
