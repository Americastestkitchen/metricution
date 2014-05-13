Metricution.BathroomsController = Ember.ArrayController.extend

  bathrooms:(->
    @.get('model')
  ).property('model')

  availableCount:(->
    @.get('bathrooms').filterBy('status', 'available').get('length')
  ).property('bathrooms.@each.status')

  availableDescription:(->
    count = @.get('availableCount')
    if count == 1
      "There is 1 available bathroom."
    else
      "There are #{@.get('availableCount')} available bathrooms."
  ).property('availableCount')

  # TODO: Move this into an adatper.
  init: ->
    url = 'ws://' + window.location.host + '/api/v1/events/bathrooms'
    socket = new WebSocket(url)
    socket.onmessage = (event) =>
      @.get('store').pushPayload('bathroom', JSON.parse(event.data))
