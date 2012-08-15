# -*- ruby -*-
require "rake"
require "rdoc/task"
require "sass"
require_relative "lib/rdoc/generator/emerald"

task :rdoc => :gen_stylesheet
desc "Converts the SCSS stylsheet to CSS."
task :gen_stylesheet do
  cd "data"
  puts "Rendering SCSS to CSS..."
  engine = Sass::Engine.new(File.read("rdoc.scss"), syntax: :scss)
  File.open("rdoc.css", "w"){|f| f.write(engine.render)}
  cd ".."
end

RDoc::Task.new do |rt|
  rt.generator = "emerald"
  rt.rdoc_files.include("**/*.rdoc", "lib/**/*.rb")
  rt.title = "Emerald RDocs"
  rt.main = "README.rdoc"
  rt.rdoc_dir = "doc"
  rt.options << "-a"
end
