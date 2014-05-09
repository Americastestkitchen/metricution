Metricution.BathroomsController = Ember.ArrayController.extend
  actions:
    refresh: ->
      @set('model', @store.find('bathroom'))
