module Metricution
  module PGEvents
    @@callbacks = {}

    def self.notify(event, payload = nil)
      connection.execute("NOTIFY #{event}, #{connection.quote(payload.to_s)}")
    end

    def self.subscribe(event, &block)
      @@callbacks[event] = block
    end

    def self.start_listening
      begin
        @@callbacks.keys.each do |event|
          connection.execute("LISTEN #{event}")
        end
        loop do
          raw_connection.wait_for_notify do |event, pid, payload|
            @@callbacks[event].call(event, payload) if @@callbacks[event]
          end
        end
      ensure
        @@callbacks.keys.each do |event|
          connection.execute("UNLISTEN #{event}")
        end
      end
    end

    private

    def self.connection
      ActiveRecord::Base.connection
    end

    def self.raw_connection
      connection.raw_connection
    end
  end
end