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

        id = message.coreid
        if message.data == "opened"
          status_text = "available"
        else if message.data == "closed"
          status_text = "occupied"
        else
          status_text = "unknown"

        statuses = $('.bathroom-statuses')
        status = statuses.find("##{id}")
        if status.length == 0
          statuses.append("<li id='#{id}'>Bathroom #{id} is #{status_text}</li>")
        else
          status.html("Bathroom #{id} is #{status_text}")
