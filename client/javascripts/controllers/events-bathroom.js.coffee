Metricution.EventsBathroomController = Ember.ObjectController.extend
  eventStreamBinding: 'content'
  statusBinding: 'content.message'

  init: ->
    url: 'ws://' + window.location.host + '/api/v1/events/bathroom'
    this.set 'statusSocket', new WebSocket url
    @statusSocket.onmessage = (event) ->
      payload = JSON.parse(event.data)
      @store.pushPayload('bathroom', payload)
      Ember.run.next =>
        @store.find('bathroom', payload.bathroom[0].id).then (msg) =>
          @get('bathroom').pushObject msg
