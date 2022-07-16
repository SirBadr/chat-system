# blog/app/services/publisher.rb
class Publisher
    # In order to publish message we need a exchange name.
    # Note that RabbitMQ does not care about the payload -
    # we will be using JSON-encoded strings
    def self.publish(message = {})
      @@connection ||= $bunny.start do |c|
        c.start
      end
      @@channel ||= @@connection.create_channel
      @@fanout ||= @@channel.fanout("applications")
      @@queue ||= @@channel.queue("applications", durable: true).tap do |q|
        q.bind("applications")
      end
      # and simply publish message
      @@fanout.publish(message.to_json, persistent: true)
    end
  end