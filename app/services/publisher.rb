# blog/app/services/publisher.rb
class Publisher
    # In order to publish message we need a exchange name.
    # Note that RabbitMQ does not care about the payload -
    # we will be using JSON-encoded strings
    def self.publish(message = {})
      @@connection ||= $bunny.tap do |c|
        c.start
      end
      @@channel ||= @@connection.create_channel
      @@fanout ||= @@channel.fanout("chatsys.messages")
      @@queue ||= @@channel.queue("chatsys.messages", durable: true).tap do |q|
        q.bind("chatsys.messages")
      end
      # and simply publish message
      @@fanout.publish(message)
    end
  end