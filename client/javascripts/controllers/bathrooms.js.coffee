Metricution.BathroomsController = Ember.ArrayController.extend

  bathrooms:(->
    @store.find('bathroom')
  ).property()

  availableCount:(->
    @.get('bathrooms').filterBy('status', 'available').get('length')
  ).property('bathrooms.@each.status')

  # TODO: Move this into an adatper.
  init: ->
    url = 'ws://' + window.location.host + '/api/v1/events/bathrooms'
    socket = new WebSocket(url)
    socket.onmessage = (event) =>
      @store.pushPayload('bathroom', JSON.parse(event.data))
