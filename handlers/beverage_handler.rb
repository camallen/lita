require 'active_support/core_ext/integer/inflections'

module Lita
  class BeverageHandler < Handler
    route /^i drank (an?|some)?\s*([\w\s]+)$/, :drink, command: true
    route /^drink stats$/, :stats, command: true

    def drink(response)
      type = response.matches[0][1].strip
      alltime_key = "#{response.user.id}.#{type}.history"
      today_key = "#{response.user.id}.#{type}.history_#{Date.today.to_s}"

      redis.rpush(alltime_key, Time.now.to_i.to_s)
      redis.rpush(today_key, Time.now.to_i.to_s)

      nth_today = redis.llen(today_key).ordinalize
      response.reply("That's your #{nth_today} #{type} today.")
    end

    def stats(response)
      response.reply("Not implemented")
    end

    Lita.register_handler(BeverageHandler)
  end
end