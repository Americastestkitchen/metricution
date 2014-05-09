# http://emberjs.com/guides/models/#toc_store
# http://emberjs.com/guides/models/pushing-records-into-the-store/

Metricution.Store = DS.Store.extend({})

# Override the default adapter with the `DS.ActiveModelAdapter` which
# is built to work nicely with the ActiveModel::Serializers gem.
Metricution.ApplicationAdapter = DS.ActiveModelAdapter.extend({
  namespace: 'api/v1'
  host: 'http://localhost:3000'
})
