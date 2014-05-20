Metricution.BathroomsController = Ember.ArrayController.extend

  # TODO: Move this into an adatper.
  init: ->
    source = new EventSource('/api/v1/events/bathrooms')
    source.addEventListener 'bathroomUpdated', (event) =>
      @get('store').pushPayload('bathroom', JSON.parse(event.data))
