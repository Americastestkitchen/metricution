# Override the default adapter with the `DS.ActiveModelAdapter` which
# is built to work nicely with the ActiveModel::Serializers gem.
Metricution.ApplicationAdapter = DS.ActiveModelAdapter.extend
  namespace: 'api/v1'
