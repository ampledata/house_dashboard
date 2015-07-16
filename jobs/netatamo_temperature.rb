require './lib/graphite'


SCHEDULER.every('10m', :first_in => 0) do
  q = Graphite.new('http://172.17.2.20:3031/render')

  target = 'netatmo.70ee5002be74.Indoor.Temperature'

  current = q.value(target, '-10min')
  points = q.points(target, '-3hour')

  _current = (current * 1.8 + 32).to_i

  points.map! do |x|
    {:x => x[:x], :y => (x[:y] * 1.8 + 32).to_i}
  end

  send_event('netatamo_temperature', { current: _current, value: _current, points: points })
end
