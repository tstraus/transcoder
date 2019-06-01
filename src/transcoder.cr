require "kemal"

module Transcoder
    count = 1
    sockets = [] of HTTP::WebSocket

    def self.printNumSockets(sockets)
        puts "connections: #{sockets.size}"
    end

    # HTTP methods
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

    # WebSocket handlers
    ws "/encode" do |socket|
        sockets.push socket
        printNumSockets(sockets)

        socket.on_message do |message|
            puts "websocket: #{message}"
        end

        socket.on_close do |_|
            sockets.delete(socket)
            printNumSockets(sockets)
        end
    end

    Kemal.run
end
