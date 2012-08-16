# -*- ruby -*-
require "rake"
require "rake/clean"
require "rdoc/task"
require "rubygems/package_task"
require "sass"
require_relative "lib/rdoc/generator/emerald"

CLEAN.include("data/stylesheets/*.css")

desc "Converts the SCSS stylsheet to CSS."
task :gen_stylesheets do
  cd "data/stylesheets"
  puts "rdoc.scss -> rdoc.css"
  engine = Sass::Engine.new(File.read("rdoc.scss"), syntax: :scss)
  File.open("rdoc.css", "w"){|f| f.write(engine.render)}
  cd "../.."
end

# Add dependencies to some default tasks
task :rdoc => :gen_stylesheets
task :gem => :gen_stylesheets

RDoc::Task.new do |rt|
  rt.generator = "emerald"
  rt.rdoc_files.include("**/*.rdoc", "lib/**/*.rb", "COPYING")
  rt.title = "Emerald RDocs"
  rt.main = "README.rdoc"
  rt.rdoc_dir = "doc"
end

load "emerald.gemspec"
Gem::PackageTask.new(GEMSPEC).define
