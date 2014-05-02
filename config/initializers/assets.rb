# Add ember/ to the asset pipeline.
Rails.application.config.assets.paths += [
  File.join(Rails.root, 'ember', 'javascripts'),
  File.join(Rails.root, 'ember', 'stylesheets')
]

Rails.application.config.assets.precompile += [
  'manifest.css',
  'manifest.js'
]
