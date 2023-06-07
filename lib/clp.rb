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
      # TODO test
      ["Clp.dll"]
    elsif RbConfig::CONFIG["host_os"] =~ /darwin/i
      if RbConfig::CONFIG["host_cpu"] =~ /arm|aarch64/i
        ["libClp.dylib", "/opt/homebrew/lib/libClp.dylib"]
      else
        ["libClp.dylib"]
      end
    else
      # coinor-libclp-dev has libClp.so
      # coinor-libclp1 has libClp.so.1
      ["libClp.so", "libClp.so.1"]
    end
  self.ffi_lib = lib_name

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
