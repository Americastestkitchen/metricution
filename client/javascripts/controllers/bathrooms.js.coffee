Metricution.BathroomsController = Ember.ArrayController.extend

  bathrooms:(->
    @get('model')
  ).property('model')

  availableCount:(->
    @get('bathrooms').filterBy('status', 'available').get('length')
  ).property('bathrooms.@each.status')

  availableDescription:(->
    count = @get('availableCount')
    if count == 1
      "There is 1 available bathroom."
    else
      "There are #{@get('availableCount')} available bathrooms."
  ).property('availableCount')

  # TODO: Move this into an adatper.
  init: ->
    url = 'ws://' + window.location.host + '/api/v1/events/bathrooms'
    socket = new WebSocket(url)
    retry_count = 1
    socket.onopen = (event) ->
      retry_count = 1
    socket.onmessage = (event) =>
      @get('store').pushPayload('bathroom', JSON.parse(event.data))
    socket.onclose = (event) ->
      id = setTimeout(->
        # Create a new socket to the host.
        closed_socket    = event.currentTarget
        socket           = new WebSocket(closed_socket.URL)
        socket.onopen    = closed_socket.onopen
        socket.onmessage = closed_socket.onmessage
        socket.onclose   = closed_socket.onclose
      # Retries with increasing delay 10 times, then simply
      # retries every 30 sec.
      , Math.min(Math.pow(retry_count, 1.45), 30) * 1000)
