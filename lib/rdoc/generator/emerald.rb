# -*- coding: utf-8 -*-
gem "rdoc"

require "pathname"
require "fileutils"
require "erb"
require "rdoc/rdoc"
require "rdoc/generator"

class RDoc::Generator::Emerald
  include FileUtils

  # Generic exception class for this generator.
  class EmeraldError < StandardError
  end

  # Test stuff.
  class MyAwesomeError < EmeraldError
  end

  # Tell RDoc about the new generator
  RDoc::RDoc.add_generator(self)

  # Description displayed in RDoc’s help.
  DESCRIPTION = "Modern generator for RDoc"

  # Root directory of this project.
  ROOT_DIR = Pathname.new(__FILE__).dirname.parent.parent.parent

  # Where to find the non-code stuff.
  DATA_DIR = ROOT_DIR + "data"

  # Main template used as the general layout.
  LAYOUT_TEMPLATE = ERB.new(File.read(DATA_DIR + "templates" + "layout.html.erb"))

  # Subtemplates injected into the main template.
  TEMPLATES = {
    :toplevel    => ERB.new(File.read(DATA_DIR + "templates" + "toplevel.html.erb")),
    :classmodule => ERB.new(File.read(DATA_DIR + "templates" + "classmodule.html.erb"))
  }

  # The version number.
  VERSION = "0.0.1-dev"

  def self.setup_options(options)
    # TODO
  end

  class << self

    protected

    # Protected foo.
    def foo
    end

    private

    # Private bar.
    def bar
    end

  end

  # Instanciates this generator. Automatically called
  # by RDoc.
  # ==Parameter
  # [options]
  #   RDoc passed the current RDoc::Options instance.
  def initialize(options)
    @options = options
    @op_dir = Pathname.pwd.expand_path + @options.op_dir
  end

  def generate(top_levels)
    @toplevels = top_levels
    @classes_and_modules = RDoc::TopLevel.all_classes_and_modules.sort_by{|klass| klass.full_name}
    @methods = @classes_and_modules.map{|mod| mod.method_list}.flatten.sort do |m1, m2|
      if m1.name_prefix == m2.name_prefix
        # If both are class or instance methods, sort by name
        m1.name <=> m2.name
      elsif m1.name_prefix == "::"
        # Class methods go first
        -1
      elsif m1.name_prefix == "#"
        # Instance methods go second
        1
      else
        # Shouldn’t happen
        nil
      end
    end

    # Create the output directory    
    mkdir @op_dir unless @op_dir.exist?

    copy_base_files
    evaluate_toplevels
    evaluate_classes_and_modules

    unless @options.main_page # If set, #evaluate_toplevels creates the index.html for us
      File.open(@op_dir + "index.html", "w") do |file|
        file.write("<!DOCTYPE HTML>\n<html><head><title>RDoc documentation</title></head><body><p>This is the RDoc documentation.</p></body></html>")
      end
    end
  end

  # Darkfish returns +nil+, hence we do this as well.
  def file_dir
    nil
  end

  # Darkfish returns +nil+, hence we do this as well.
  def class_dir
    nil
  end

  protected

  def root_path(set_to = nil)
    if set_to
      @root_path = Pathname.new(set_to)
    else
      @root_path ||= Pathname.new("./")
    end
  end

  def title(set_to = nil)
    if set_to
      @title = set_to
    else
      @title ||= ""
    end
  end

  # Takes a RDoc::TopLevel and transforms it into a complete pathname
  # relative to the output directory. Filename alterations
  # done by RDoc’s crossref-HTML formatter are honoured. Note you
  # have to prepend #root_path to get a complete href.
  def rdocize_toplevel(toplevel)
    Pathname.new("#{toplevel.relative_name.gsub(".", "_")}.html")
  end

  # Takes a RDoc::ClassModule and transforms it into a complete pathname
  # relative to the output directory. Filename alterations
  # done by RDoc’s crossref-HTML formatter are honoured. Note you
  # have to prepend #root_path to get a complete href.
  def rdocize_classmod(classmod)
    Pathname.new(classmod.full_name.split("::").join("/") + ".html")
  end

  private

  def copy_base_files
    cp DATA_DIR + "rdoc.css", @op_dir
    cp DATA_DIR + "jquery.js", @op_dir
    cp DATA_DIR + "emerald.js", @op_dir
  end

  def evaluate_toplevels
    @toplevels.each do |toplevel|
      root_path("../" * (toplevel.relative_name.split("/").count - 1)) # Last component is a filename
      title toplevel.relative_name

      # Create the path to the file if necessary
      path = @op_dir + rdocize_toplevel(toplevel)
      mkdir_p path.parent unless path.parent.exist?

      # Evaluate the actual file documentation
      File.open(path, "w") do |file|
        file.write(render(:toplevel, binding))
      end

      # If this toplevel is supposed to be the main file,
      # copy it’s content to the index.html file.
      if toplevel.relative_name == @options.main_page
        root_path "./" # We *are* at the top here

        File.open(@op_dir + "index.html", "w") do |file|
          file.write(render(:toplevel, binding))
        end
      end
    end
  end

  def evaluate_classes_and_modules
    @classes_and_modules.each do |classmod|

      path = @op_dir + rdocize_classmod(classmod)

      mkdir_p   path.parent unless path.parent.directory?
      title     classmod.full_name
      root_path "../" * (classmod.full_name.split("::").count - 1) # Last element is a file


      File.open(path, "w") do |file|
        file.write(render(:classmodule, binding))
      end
    end
  end

  # Renders the subtemplate +template_name+ in the +context+ of the
  # given binding, then injects it into the main template (which is
  # evaluated in the same +context+).
  #
  # Returns the resulting string.
  def render(template_name, context)
    render_into_layout{TEMPLATES[template_name].result(context)}
  end

  # Renders into the main layout. The return value of the block
  # passed to this method will be placed in the layout in place
  # of the +yield+ expression.
  def render_into_layout
    LAYOUT_TEMPLATE.result(binding)
  end

end
