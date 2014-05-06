#= require jquery
#= require jquery_ujs
#= require_tree .
#= require_self

# Metricution Namespace.
App = window.Metricution ||= {}

$ ->
  access_token = App.SPARK_ACCESS_TOKEN

  $.get '/api/v1/bathrooms', (bathrooms) ->
    $.each bathrooms, (_, bathroom) ->
      es = new EventSource("https://api.spark.io/v1/devices/#{bathroom.sparkcore_id}/events/door/?access_token=#{access_token}")
      es.addEventListener 'door', (event) ->
        message = $.parseJSON(event.data)

        # I'm being very paranoid, these two values should really ALWAYS
        # be the same.
        if bathroom.sparkcore_id == message.coreid
          if message.data == "opened"
            status_text = "available"
          else if message.data == "closed"
            status_text = "occupied"
          else
            status_text = "unknown"

          statuses = $('.bathroom-statuses')
          status = statuses.find("##{bathroom.sparkcore_id}")
          if status.length == 0
            statuses.append("<li id='#{bathroom.sparkcore_id}' class='#{status_text}'>#{bathroom.name}</li>")
          else
            status.removeClass()
            status.addClass(status_text)

        # If they don't match for some reason remove the element because
        # who knows what's going on.
        #
        # TODO: Error state for a bathroom.
        else
          statuses.remove("##{bathroom.sparkcore_id}")
