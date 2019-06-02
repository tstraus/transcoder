require "kemal"

module Transcoder
    count = 1
    sockets = [] of HTTP::WebSocket

    def self.printNumSockets(sockets)
        puts "connections: #{sockets.size}"
    end


    def self.printProgress(id, progress)
        puts "#{id}: #{progress} %"
    end

    # HTTP methods
    get "/" do |env|
        env.redirect "index.html"
    end

    post "/encode" do |env|
        input = env.params.json
        puts input

        # get the id of this transcode and update count
        id = count
        count += 1

        spawn do # start the transcoding process
            p = Process.new("./handbrake.sh", args: [input["file"].to_s, id.to_s], output: Process::Redirect::Pipe)
            io = p.output
            progress = 0.0

            spawn do # update the progress percentage in the background
                while p.exists? && !io.closed?
                    while true
                        line = io.gets

                        if line.is_a?(String)
                            if line.includes?("\"Progress\"")
                                progress = line.split(": ")[1].split(',')[0].to_f * 100.0 # get the percentage
                            end
                        else
                            break
                        end
                    end

                    sleep 0.5.seconds
                end

               progress = 100.0
            end

            while p.exists?
                printProgress(id, progress)

                sleep 1.seconds
            end

            p.wait()

            progress = 100.0
            printProgress(id, progress)
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
