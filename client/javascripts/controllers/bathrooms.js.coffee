Metricution.BathroomsController = Ember.ArrayController.extend

  # TODO: Move this into an adatper.
  init: ->
    if !!window.EventSource
      source = new EventSource('/api/v1/events/bathrooms')
      source.addEventListener 'bathroom', (event) ->
        console.log event.data
        @get('store').pushPayload('bathroom', event.data)
    else
      # Result to xhr polling :(

    # socket = new WebSocket('ws://' + window.location.host + '/api/v1/events/bathrooms')
    # retry_count = 1
    # socket.onopen = (event) =>
    #   Ember.Logger.info 'Websocket connected to host.'
    #   retry_count = 1
    # socket.onmessage = (event) =>
    #   @get('store').pushPayload('bathroom', JSON.parse(event.data))
    # socket.onclose = (event) =>
    #   id = setTimeout(=>
    #     Ember.Logger.warn "Websocket not open. Trying to reconnect (#{retry_count++})."
    #     # Create a new socket to the host.
    #     closed_socket    = event.currentTarget
    #     socket           = new WebSocket(closed_socket.URL)
    #     socket.onopen    = closed_socket.onopen
    #     socket.onmessage = closed_socket.onmessage
    #     socket.onclose   = closed_socket.onclose
    #   # Retries with increasing delay 10 times, then simply
    #   # retries every 30 sec.
    #   , Math.min(Math.pow(retry_count, 1.45), 30) * 1000)
