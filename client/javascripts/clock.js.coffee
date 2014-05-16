Metricution.Clock = Ember.Object.extend
  second: null
  minute: null
  hour:   null

  init: ->
    @tick()

  tick: ->
    now = new Date()

    @setProperties
      second: now.getSeconds()
      minute: now.getMinutes()
      hour:   now.getHours()

    setTimeout(=>
      @tick()
    , 1000)
