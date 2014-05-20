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

    # <3 Rails.
    class Writer
      WHITELISTED_OPTIONS = %w(retry event id)

      def initialize(stream, options = {})
        @stream = stream
        @options = options
      end

      def close
        @stream.close
      end

      def write(string, options = {})
        options = @options.merge(options).stringify_keys

        WHITELISTED_OPTIONS.each do |option|
          if (value = options[option])
            @stream.write "#{option}: #{value}\n"
          end
        end

        if string
          string = string.gsub("\n", "\ndata: ")
          @stream.write("data: #{string}\n\n")
        end
      rescue IOError => e  # Client disconnected.
        @stream.close
      end
    end

  end
end
