Metricution.BathroomsController = Ember.ArrayController.extend

  init: ->
    source = new EventSource('/api/v1/events/bathrooms')
    source.addEventListener 'bathroom', (event) =>
      @get('store').pushPayload('bathroom', JSON.parse(event.data))
