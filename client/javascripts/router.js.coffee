# For more information see: http://emberjs.com/guides/routing/
Metricution.Router.map ->
  @resource('bathrooms')

# Get rid of the # in the routes.
Metricution.Router.reopen
  location: 'history'