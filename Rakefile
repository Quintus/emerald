require "rake"
require "rdoc/task"
require_relative "lib/rdoc/generator/emerald"

RDoc::Task.new do |rt|
  rt.generator = "emerald"
  rt.rdoc_files.include("**/*.rdoc", "lib/**/*.rb")
  rt.title = "Emerald RDocs"
  rt.main = "README.rdoc"
  rt.rdoc_dir = "doc"
end
