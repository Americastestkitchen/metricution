# Add client/ to the asset pipeline.
Rails.application.config.assets.paths += [
  File.join(Rails.root, 'client', 'javascripts'),
  File.join(Rails.root, 'client', 'stylesheets')
]

Rails.application.config.assets.precompile += [
  'manifest.css',
  'manifest.js'
]
