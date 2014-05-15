Ember.Handlebars.registerBoundHelper 'moment', (datetime, format) ->
  moment(datetime).format(format)
