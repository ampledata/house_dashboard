require "./lib/graphite"

# last started parkingsessions
SCHEDULER.every('1m', :first_in => 0) do
    # Create an instance of our helper class
    q = Graphite.new("http://172.17.2.20:3031/render")

    target = "tomato.eagle.gauge-demand_f"

    # get the current value
    current = q.value(target, "-5min")
    # get points for the last half hour
    points = q.points(target, "-1hour")

    # send to dashboard, so the number the meter and the graph widget can understand it
    send_event('eagle', { current: current, value: current, points: points })
end
