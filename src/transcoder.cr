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

    def self.sendProgress(sockets, progress)
        sockets.each do |s|
            s.send progress.to_json
        end
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

        inputFile = "#{input["file"].to_s}"
        outputFile = "samples/out_#{id.to_s}.mp4"

        spawn do # start the transcoding process
            p = Process.new("HandBrakeCLI", output: Process::Redirect::Pipe,
                args: [
                    "--json",
                    "--input=#{inputFile}",
                    "--output=#{outputFile}",
                    "--encoder=x264",
                    #"--encoder=x265",
                    "--encoder-preset=fast",
                    "--encoder-profile=auto",
                    "--quality=18.0",
                    "--aencoder=copy"
                ])

            io = p.output
            progress = 0.0
            lastSentProgress = progress
            sendProgress(sockets, {id: id, input: inputFile, output: outputFile, progress: progress})

            spawn do # update the progress percentage in the background
                while p.exists? && !io.closed?
                    while true
                        line = io.gets

                        if line.is_a?(String)
                            if line.includes?("\"Progress\"") # get the percentage
                                progress = line.split(": ")[1].split(',')[0].to_f * 100.0
                            end
                        else
                            break
                        end
                    end

                    sleep 0.5.seconds
                end

               progress = 100.0
            end

            while p.exists? # print and send progress
                if progress > lastSentProgress
                    printProgress(id, progress)

                    # push progress to clients
                    sendProgress(sockets, {id: id, input: inputFile, output: outputFile, progress: progress})
                    lastSentProgress = progress
                end

                sleep 2.seconds
            end

            p.wait()

            progress = 100.0
            printProgress(id, progress)
            sendProgress(sockets, {id: id, input: inputFile, output: outputFile, progress: progress})
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
