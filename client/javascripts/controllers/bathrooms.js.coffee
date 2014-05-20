Metricution.BathroomsController = Ember.ArrayController.extend

  # TODO: Move this into an adatper.
  init: ->
    source = new EventSource('/api/v1/events/bathrooms')
    source.addEventListener 'bathroomUpdate', (event) =>
      console.log event.data
      @get('store').pushPayload('bathroom', JSON.parse(event.data))
    source.addEventListener 'browserReload', (event) =>
      location.reload()
