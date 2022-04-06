module Clp
  module FFI
    extend Fiddle::Importer

    libs = Array(Clp.ffi_lib).dup
    begin
      dlload Fiddle.dlopen(libs.shift)
    rescue Fiddle::DLError => e
      retry if libs.any?
      raise e
    end

    # https://github.com/coin-or/Clp/blob/master/src/Clp_C_Interface.h

    OBJ_SENSE = {
      minimize: 1,
      maximize: -1
    }

    STATUS = [:optimal, :primal_infeasible, :dual_infeasible, :stopped, :error]

    typealias "CoinBigIndex", "int"

    # version info
    extern "char * Clp_Version(void)"

    # constructors and destructors
    extern "Clp_Simplex * Clp_newModel(void)"
    extern "void Clp_deleteModel(Clp_Simplex *model)"
    extern "Clp_Solve * ClpSolve_new()"
    extern "void ClpSolve_delete(Clp_Solve *solve)"

    # load models
    extern "void Clp_loadProblem(Clp_Simplex *model, int numcols, int numrows, CoinBigIndex *start, int *index, double *value, double *collb, double *colub, double *obj, double *rowlb, double *rowub)"
    extern "int Clp_readMps(Clp_Simplex *model, char *filename, int keepNames, int ignoreErrors)"
    if Gem::Version.new(FFI.Clp_Version) >= Gem::Version.new("1.17.2")
      extern "int Clp_writeMps(Clp_Simplex *model, char *filename, int formatType, int numberAcross, double objSense)"
    end

    # getters and setters
    extern "int Clp_numberRows(Clp_Simplex *model)"
    extern "int Clp_numberColumns(Clp_Simplex *model)"
    extern "double Clp_objectiveOffset(Clp_Simplex *model)"
    extern "void Clp_setObjectiveOffset(Clp_Simplex *model, double value)"
    extern "int Clp_status(Clp_Simplex *model)"
    extern "double Clp_getObjSense(Clp_Simplex *model)"
    extern "void Clp_setObjSense(Clp_Simplex *model, double objsen)"
    extern "double * Clp_primalRowSolution(Clp_Simplex *model)"
    extern "double * Clp_primalColumnSolution(Clp_Simplex *model)"
    extern "double * Clp_dualRowSolution(Clp_Simplex *model)"
    extern "double * Clp_dualColumnSolution(Clp_Simplex *model)"
    extern "double * Clp_objective(Clp_Simplex *model)"
    extern "CoinBigIndex Clp_getNumElements(Clp_Simplex *model)"
    extern "CoinBigIndex * Clp_getVectorStarts(Clp_Simplex *model)"
    extern "int * Clp_getIndices(Clp_Simplex *model)"
    extern "int * Clp_getVectorLengths(Clp_Simplex *model)"
    extern "double * Clp_getElements(Clp_Simplex *model)"
    extern "double Clp_objectiveValue(Clp_Simplex *model)"
    extern "void Clp_setLogLevel(Clp_Simplex *model, int value)"

    # solve
    extern "int Clp_initialSolve(Clp_Simplex *model)"
  end
end
