$bunny = Bunny.new(:host => "amqp://guest:guest@my_rabbit:5672")
Sneakers.configure(:amqp => "amqp://guest:guest@my_rabbit:5672")