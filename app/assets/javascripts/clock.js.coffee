# implementation based on: https://www.sitepoint.com/build-javascript-countdown-timer-no-dependencies/
# with custom modifications

class Clock
  getTimeRemaining: (endtime) ->
    t = Date.parse(endtime) - Date.parse(new Date)
    seconds = Math.floor(t / 1000 % 60)
    minutes = Math.floor(t / 1000 / 60 % 60)
    hours = Math.floor(t / (1000 * 60 * 60) % 24)
    days = Math.floor(t / (1000 * 60 * 60 * 24))
    {
      'total': t
      'days': Math.max(days, 0)
      'hours': Math.max(hours, 0)
      'minutes': Math.max(minutes, 0)
      'seconds': Math.max(seconds, 0)
    }

  initializeClock: (id, endtime, countdown_reached_callback = () -> {}) ->
    clock = document.getElementById(id)
    daysSpan = clock.querySelector('.days')
    hoursSpan = clock.querySelector('.hours')
    minutesSpan = clock.querySelector('.minutes')
    secondsSpan = clock.querySelector('.seconds')

    updateClock = =>
      t = @getTimeRemaining(endtime)
      daysSpan.innerHTML = t.days
      hoursSpan.innerHTML = ('0' + t.hours).slice(-2)
      minutesSpan.innerHTML = ('0' + t.minutes).slice(-2)
      secondsSpan.innerHTML = ('0' + t.seconds).slice(-2)

      if t.total <= 0
        clearInterval timeinterval
        countdown_reached_callback()
      return

    timeinterval = setInterval(updateClock, 1000)
    updateClock()
    return

window.Clock = Clock
