require './lib/graphite'


SCHEDULER.every('10m', :first_in => 0) do
  q = Graphite.new('http://172.17.2.20:3031/render')

  target = 'netatmo.70ee5002be74.Indoor.CO2'

  current = q.value(target, '-10min')
  points = q.points(target, '-3hour')

  send_event('netatamo_co2', { current: current, value: current, points: points })
end
