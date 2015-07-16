#!/usr/bin/env ruby


require 'json'

require 'slate'


class Graphite
    # Pass in the url to where you graphite instance is hosted
    def initialize(url)
        @client = Slate.configure do |config|
          config.endpoint = url
          config.timeout  = 30  # In seconds (default: 10)
        end
    end

    def get_value(datapoint)
        value = if datapoint
            datapoint[0] || 0
        else
            0
        end

        return value.round(2)
    end

    # This is the raw query method, it will fetch the
    # JSON from the Graphite and parse it
    def query(name, since=nil)
        since ||= '-2min'
        graph = Slate::Graph.new(@client)
        graph.from = since
        graph << Slate::Target.build(name)
        json_graph = JSON.parse(graph.download(:json), :symbolize_names => true)
        return json_graph.first
    end

    # This is high-level function that will fetch a set of datapoints
    # since the given start point and convert it into a format that the
    # graph widget of Dashing can understand
    def points(name, since=nil)
        stats = query(name, since)
        datapoints = stats[:datapoints]

        points = []
        count = 1

        (datapoints.select { |el| not el[0].nil? }).each do |item|
            points << { x: count, y: get_value(item)}
            count += 1
        end

        return points
    end

    # Not all Dashing widgets need a set of points, often just
    # the current value is enough. This method does just that, it fetches
    # the value for last point-in-time and returns it
    def value(name, since=nil)
        stats = query(name, since)
        last = (stats[:datapoints].select { |el| not el[0].nil? }).last
        return get_value(last)
    end
end
