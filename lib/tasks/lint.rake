require 'rubocop/rake_task'

desc 'Lint the application. (Ruby/Coffeescript)'
task lint: ['lint:rails', 'lint:ruby', 'lint:coffee']

namespace :lint do
  Rubocop::RakeTask.new(:rails) do |task|
    task.options = [
      '-R'
    ]
    task.patterns = [
      'app/**/*.rb'
    ]
  end

  Rubocop::RakeTask.new(:ruby) do |task|
    task.patterns = [
      'lib/**/*.rb',
      'lib/**/*.rake'
    ]
  end

  desc 'Lint Coffeescript'
  task :coffee do
    puts 'Running coffeelint...'
    pass = system('coffeelint .')
    fail 'failed coffeescript linting' unless pass
  end
end

Rake::Task['spec'].enhance do
  Rake::Task['lint'].invoke
end
