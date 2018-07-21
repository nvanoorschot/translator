# frozen_string_literal: true

desc 'Run tests'
task :test do
  require 'rubygems'
  require 'cucumber'
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new(:test) do |t|
    t.cucumber_opts = 'features --format pretty'
  end
end

desc 'Default: run test.'
task default: :test

task :console do
  begin
    require 'pry'
    console = Pry
  rescue LoadError
    require 'irb'
    require 'irb/completion'
    console = IRB
  end

  require 'translator'
  ARGV.clear
  console.start
end
