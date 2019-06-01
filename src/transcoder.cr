require "kemal"

module TRANSCODER
    count = 1

    get "/" do |env|
        env.redirect "index.html"
    end

    post "/encode" do |env|
        input = env.params.json
        puts input

        spawn do
            p = Process.new("./handbrake.sh", args: [input["file"].to_s, count.to_s])

            count += 1
            p.wait()
            puts "done"
        end
    end

    Kemal.run
end
