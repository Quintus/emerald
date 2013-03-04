# -*- mode: ruby; coding: utf-8 -*-
GEMSPEC = Gem::Specification.new do |spec|
  # Descriptive information
  spec.name        = "emerald"
  spec.license     = "GPLv3"
  spec.summary     = "The only RDoc generator that makes your Ruby documentation a jewel, too"
  spec.description =<<-EOF
Emerald is a generator for RDoc, like standard Darkfish, but looks
much better (and does not have this touch of green). It is inspired
by Hanna, but does not share any code with it (and does not use frames!).
  EOF

  # General information
  spec.version               = File.read("VERSION").gsub("-", ".")
  spec.author                = "Marvin Gülker"
  spec.email                 = "quintus@quintilianus.eu"
  spec.homepage              = "https://github.com/Quintus/emerald"
  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = ">= 1.9"

  # Dependencies
  spec.add_dependency("rdoc", ">= 4.0.0")
  spec.add_dependency("sass", ">= 3.2.0")

  # Gem contents
  spec.files = Dir["**/*.rb"] +
    Dir["**/*.rdoc"] +
    Dir["data/stylesheets/*.css"] +
    Dir["data/javascripts/*.js"] +
    Dir["data/images/*.png"] +
    Dir["data/templates/*.html.erb"] +
    ["VERSION"]

  # RDoc extra information
  spec.extra_rdoc_files = Dir["**/*.rdoc"]
  spec.rdoc_options << "-t" << "Emerald RDocs" << "-m" << "README.rdoc"
end
