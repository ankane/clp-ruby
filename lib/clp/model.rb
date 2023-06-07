module Clp
  class Model
    def initialize
      @model = FFI.Clp_newModel
      ObjectSpace.define_finalizer(@model, self.class.finalize(@model.to_i))

      FFI.Clp_setLogLevel(model, 0)
    end

    def load_problem(sense:, start:, index:, value:, col_lower:, col_upper:, obj:, row_lower:, row_upper:, offset: 0)
      start_size = start.size
      index_size = index.size
      num_cols = col_lower.size
      num_rows = row_lower.size

      FFI.Clp_loadProblem(
        model, num_cols, num_rows,
        big_index_array(start, start_size), int_array(index, index_size), double_array(value, index_size),
        double_array(col_lower, num_cols), double_array(col_upper, num_cols), double_array(obj, num_cols),
        double_array(row_lower, num_rows), double_array(row_upper, num_rows)
      )
      FFI.Clp_setObjSense(model, FFI::OBJ_SENSE.fetch(sense))
      FFI.Clp_setObjectiveOffset(model, offset)
    end

    def read_mps(filename)
      check_status FFI.Clp_readMps(model, filename, 0, 0)
    end

    def write_mps(filename)
      unless FFI.respond_to?(:Clp_writeMps)
        raise Error, "This feature requires Clp 1.17.2+"
      end
      check_status FFI.Clp_writeMps(model, filename, 0, 1, 0)
    end

    def solve(log_level: nil, time_limit: nil)
      with_options(log_level: log_level, time_limit: time_limit) do
        # do not check status
        FFI.Clp_initialSolve(model)
      end

      num_rows = FFI.Clp_numberRows(model)
      num_cols = FFI.Clp_numberColumns(model)

      {
        status: FFI::STATUS[FFI.Clp_status(model)],
        objective: FFI.Clp_objectiveValue(model),
        primal_row: read_double_array(FFI.Clp_primalRowSolution(model), num_rows),
        primal_col: read_double_array(FFI.Clp_primalColumnSolution(model), num_cols),
        dual_row: read_double_array(FFI.Clp_dualRowSolution(model), num_rows),
        dual_col: read_double_array(FFI.Clp_dualColumnSolution(model), num_cols)
      }
    end

    def self.finalize(addr)
      # must use proc instead of stabby lambda
      proc { FFI.Clp_deleteModel(addr) }
    end

    private

    def model
      @model
    end

    def check_status(status)
      if status != 0
        raise Error, "Bad status: #{status}"
      end
    end

    def double_array(value, size)
      base_array(value, size, "d")
    end

    def int_array(value, size)
      base_array(value, size, "i!")
    end
    alias_method :big_index_array, :int_array

    def base_array(value, size, format)
      if value.size != size
        # TODO add variable name to message
        raise ArgumentError, "wrong size (given #{value.size}, expected #{size})"
      end
      Fiddle::Pointer[value.pack("#{format}#{size}")]
    end

    def read_double_array(ptr, size)
      ptr[0, size * Fiddle::SIZEOF_DOUBLE].unpack("d#{size}")
    end

    def with_options(log_level:, time_limit:)
      if log_level
        previous_log_level = FFI.Clp_logLevel(model)
        FFI.Clp_setLogLevel(model, log_level)
      end

      if time_limit
        previous_time_limit = FFI.Clp_maximumSeconds(model)
        FFI.Clp_setMaximumSeconds(model, time_limit)
      end

      yield
    ensure
      FFI.Clp_setLogLevel(model, previous_log_level) if previous_log_level
      FFI.Clp_setMaximumSeconds(model, previous_time_limit) if previous_time_limit
    end
  end
end
