require 'net/http'

module Metricution
  module SSE

    class Event
      attr_reader :name, :data

      def initialize(message)
        parts = message.split("\n")
        parts.each do |part|
          k, v = part.split(": ")
          case k
          when "event"
            @name = v
          when "data"
            @data = v
          end
        end
      end
    end

    class Reader
      def initialize(http, request)
        @http = http
        @request = request
        @callbacks = {}
      end

      def subscribe(event, &block)
        @callbacks[event] = block
      end

      def start(options = {})
        buffer = ""
        @http.request(@request) do |response|
          if options[:verbose]
            puts "Connection to #{@request.uri} established."
            puts "Subscribed to #{@callbacks.keys.join(', ')}."
          end

          response.read_body do |chunk|
            # Check for \n\n at the end of the chunk.
            if chunk[-2..-1] == "\n\n"
              event = Event.new(buffer + chunk[0..-3])
              if @callbacks[event.name]
                @callbacks[event.name].call(event.data)
                puts "#{event.name} : #{event.data}" if options[:verbose]
              end
              buffer = ""
              next
            end

            # Time to check for \n\n in the middle of the chunk
            left, right = chunk.split('\n\n')
            if chunk != left
              Event.new(buffer + left)
              if @callbacks[event.name]
                @callbacks[event.name].call(event.data)
              end
              buffer = right || ""
              next
            end

            # No \n\n
            buffer += chunk
          end
        end
      end
    end

    class Writer
      def initialize(io)
        @io = io
      end

      def write(object, options = {})
        options.each { |k,v| @io.write "#{k}: #{v}\n" }
        @io.write "data: #{JSON.dump(object)}\n\n"
      end

      def close
        @io.close
      end
    end

  end
end
