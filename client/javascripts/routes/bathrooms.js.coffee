Metricution.BathroomsRoute = Ember.Route.extend
  model: ->
    @store.find('bathroom')