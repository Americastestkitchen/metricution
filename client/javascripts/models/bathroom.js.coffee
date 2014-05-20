Metricution.Bathroom = DS.Model.extend
  name: DS.attr('string')
  sparkcoreId: DS.attr('string')
  status: DS.attr('string')
  statusUpdatedAt: DS.attr('date')
  statusUpdatedAtRelative:(->
    moment(@get('statusUpdatedAt')).fromNow()
  ).property('statusUpdatedAt', 'clock.second')
