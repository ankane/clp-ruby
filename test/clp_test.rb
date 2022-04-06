require_relative "test_helper"

class ClpTest < Minitest::Test
  def test_lib_version
    assert_match(/\A\d+\.\d+\.\d+\z/, Clp.lib_version)
  end

  def test_load_problem
    model =
      Clp.load_problem(
        sense: :minimize,
        start: [0, 3, 6],
        index: [0, 1, 2, 0, 1, 2],
        value: [2, 3, 2, 2, 4, 1],
        col_lower: [0, 0],
        col_upper: [1e30, 1e30],
        obj: [8, 10],
        row_lower: [7, 12, 6],
        row_upper: [1e30, 1e30, 1e30]
      )

    # TODO improve
    model.write_mps("/tmp/test.mps")
    assert_equal File.binread("test/support/test.mps"), File.binread("/tmp/test.mps")

    res = model.solve
    assert_equal :optimal, res[:status]
    assert_in_delta 31.2, res[:objective]
    assert_elements_in_delta [7.2, 12, 6], res[:primal_row]
    assert_elements_in_delta [2.4, 1.2], res[:primal_col]
    assert_elements_in_delta [0, 2.4, 0.4], res[:dual_row]
    assert_elements_in_delta [0, 0], res[:dual_col]
  end

  def test_read_mps
    model = Clp.read_mps("test/support/test.mps")
    res = model.solve
    assert_equal :optimal, res[:status]
    assert_in_delta 31.2, res[:objective]
    assert_elements_in_delta [7.2, 12, 6], res[:primal_row]
    assert_elements_in_delta [2.4, 1.2], res[:primal_col]
    assert_elements_in_delta [0, 2.4, 0.4], res[:dual_row]
    assert_elements_in_delta [0, 0], res[:dual_col]
  end
end
