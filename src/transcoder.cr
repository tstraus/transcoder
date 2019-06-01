require "kemal"

module TRANSCODER
    stop = false
    count = 1
    sockets = [] of HTTP::WebSocket

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

        socket.on_message do |message|
            puts "websocket: #{message}"
        end

        socket.on_close do |_|
            sockets.delete(socket)
        end
    end

    # monitor connections
    spawn do
        prevSocketsSize = sockets.size
        while !stop
            sleep 1.seconds

            if prevSocketsSize != sockets.size
                prevSocketsSize = sockets.size
                puts "connections: #{prevSocketsSize}"
            end
        end
    end

    Kemal.run
end
