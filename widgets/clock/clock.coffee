class Dashing.Clock extends Dashing.Widget

  ready: ->
    setInterval(@startTime, 500)

  startTime: =>
    today = new Date()

    h = today.getHours()
    m = today.getMinutes()
    s = today.getSeconds()
    mm = @formatMeridiem(h)
    h = @formatHour(h)
    m = @formatTime(m)
    s = @formatTime(s)
    @set('time', h + ":" + m + " " + mm)
    @set('date', today.toDateString())

  formatTime: (i) ->
    if i < 10 then "0" + i else i

  formatHour: (h) ->
    (h + 24) % 12 || 12

  formatMeridiem: (h) ->
    if h > 11 then "PM" else "AM"
