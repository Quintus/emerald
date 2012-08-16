# -*- coding: utf-8 -*-

# This mixin module contains the extra options Emerald
# adds to the default RDoc ones. It is used in the
# RDoc::Generator::Emerald::setup_options method.
module RDoc::Generator::Emerald::Options

  # Tells RDoc’s OptionParser about the new options when
  # the RDoc::Options object is extended with this mixin.
  def self.extended(options)
    op = options.option_parser

    op.separator ""
    op.separator "Emerald generator options:"
    op.separator ""

    op.on("--[no-]generate-toc",
          "Enables or disables generation of the",
          "table of contents (ToC) for toplevel files."){|val| options.generate_toc = val}
  end

  # Whether or not to generate a Table of Contents (ToC) for
  # toplevel files. Defaults to true.
  #
  # Note that the mechanism is implemented in JavaScript,
  # which has therefore to be enabled in your browser.
  def generate_toc
    @generate_toc = true unless defined?(@generate_toc)
    @generate_toc
  end

  # Setter for #generate_toc.
  def generate_toc=(val)
    @generate_toc = val
  end

end
