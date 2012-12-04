require 'bundler'  
Bundler::GemHelper.install_tasks

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end

task :default do
  system "jasmine-headless-webkit -c"
end