#= require jquery
#= require moment
#= require handlebars
#= require ember
#= require ember-data
#= require_self
#= require adapter
#= require clock
#= require router
#= require store
#= require_tree ./controllers
#= require_tree ./helpers
#= require_tree ./models
#= require_tree ./routes
#= require_tree ./templates

window.Metricution = Ember.Application.create
  ready: ->
    @register('clock:second', Metricution.Clock, { singleton: true })
    @inject('controller', 'clock', 'clock:second')
    @inject('model', 'clock', 'clock:second')
