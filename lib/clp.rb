# stdlib
require "fiddle/import"

# modules
require "clp/model"
require "clp/version"

module Clp
  class Error < StandardError; end

  class << self
    attr_accessor :ffi_lib
  end
  lib_name =
    if Gem.win_platform?
      "clp.dll"
    elsif RbConfig::CONFIG["host_os"] =~ /darwin/i
      "libclp.dylib"
    else
      "libclp.so"
    end
  self.ffi_lib = [lib_name]

  # friendlier error message
  autoload :FFI, "clp/ffi"

  def self.lib_version
    FFI.Clp_Version.to_s
  end

  def self.read_mps(filename)
    model = Model.new
    model.read_mps(filename)
    model
  end

  def self.load_problem(**options)
    model = Model.new
    model.load_problem(**options)
    model
  end
end
