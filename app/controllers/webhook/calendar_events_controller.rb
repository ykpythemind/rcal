class Webhook::CalendarEventsController < ApplicationController
  skip_forgery_protection

  def create
    puts params
    channel_id = request.headers["X-Goog-Channel-ID"]
    channel_resource_id = request.headers["X-Goog-Resource-ID"]

    puts(channel_id)
    puts(channel_resource_id)

    request.headers.each do |key, value|
      puts "#{key}: #{value}"
      if key.start_with?("X-Goog")
        puts("#{key}: #{value}")
      end
    end

    head :ok
  end
end
