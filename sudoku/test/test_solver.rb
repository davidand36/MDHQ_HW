# test_solver.rb
#
# Tests for Sudoku::Solver

require 'test/unit'
require 'stringio'
require_relative '../lib/sudoku/exception'
require_relative '../lib/sudoku/puzzle'
require_relative '../lib/sudoku/solver'

class TestSolver < Test::Unit::TestCase

  #=============================================================================

  def test_easy
    puzzle = Sudoku::Puzzle.new
    bd = [ [ 0, 0, 0,  6, 0, 0,  0, 2, 0 ],
           [ 7, 0, 0,  0, 0, 0,  3, 4, 0 ],
           [ 5, 0, 0,  3, 0, 7,  0, 0, 0 ],
           [ 0, 0, 0,  0, 0, 0,  1, 0, 0 ],
           [ 0, 0, 9,  0, 0, 0,  0, 0, 2 ],
           [ 2, 3, 0,  0, 0, 1,  0, 5, 6 ],
           [ 9, 8, 0,  0, 0, 0,  6, 1, 5 ],
           [ 0, 1, 2,  5, 0, 4,  9, 0, 3 ],
           [ 0, 0, 7,  0, 0, 0,  0, 0, 0 ] ]
    solution = [ [ 8, 4, 3,  6, 1, 9,  5, 2, 7 ],
                 [ 7, 9, 6,  8, 2, 5,  3, 4, 1 ],
                 [ 5, 2, 1,  3, 4, 7,  8, 6, 9 ],
                 [ 4, 7, 5,  2, 6, 3,  1, 9, 8 ],
                 [ 1, 6, 9,  4, 5, 8,  7, 3, 2 ],
                 [ 2, 3, 8,  9, 7, 1,  4, 5, 6 ],
                 [ 9, 8, 4,  7, 3, 2,  6, 1, 5 ],
                 [ 6, 1, 2,  5, 8, 4,  9, 7, 3 ],
                 [ 3, 5, 7,  1, 9, 6,  2, 8, 4 ] ]
    puzzle.set_board( bd )
    solver = Sudoku::Solver.new( puzzle )
    result = solver.solve
    assert_equal true, result[ :success ]
    assert_equal solution, puzzle.board
  end
  
  #-----------------------------------------------------------------------------

  def test_moderate
    puzzle = Sudoku::Puzzle.new
    bd = [ [ 0, 0, 0,  0, 0, 8,  0, 0, 1 ],
           [ 0, 0, 4,  9, 0, 0,  0, 6, 0 ],
           [ 8, 0, 3,  0, 0, 0,  4, 0, 0 ],
           [ 2, 7, 0,  0, 0, 9,  8, 0, 0 ],
           [ 0, 0, 0,  1, 0, 0,  0, 0, 5 ],
           [ 0, 0, 0,  0, 2, 5,  0, 0, 6 ],
           [ 0, 8, 0,  0, 9, 0,  0, 0, 2 ],
           [ 0, 0, 0,  6, 0, 0,  0, 5, 0 ],
           [ 0, 0, 0,  2, 0, 1,  7, 0, 0 ] ]
    solution = [ [ 6, 5, 2,  4, 7, 8,  9, 3, 1 ],
                 [ 7, 1, 4,  9, 3, 2,  5, 6, 8 ],
                 [ 8, 9, 3,  5, 1, 6,  4, 2, 7 ],
                 [ 2, 7, 5,  3, 6, 9,  8, 1, 4 ],
                 [ 3, 6, 8,  1, 4, 7,  2, 9, 5 ],
                 [ 1, 4, 9,  8, 2, 5,  3, 7, 6 ],
                 [ 5, 8, 1,  7, 9, 3,  6, 4, 2 ],
                 [ 9, 2, 7,  6, 8, 4,  1, 5, 3 ],
                 [ 4, 3, 6,  2, 5, 1,  7, 8, 9 ] ]
    puzzle.set_board( bd )
    solver = Sudoku::Solver.new( puzzle )
    result = solver.solve
    assert_equal true, result[ :success ]
    assert_equal solution, puzzle.board
  end
  
  #-----------------------------------------------------------------------------

  def test_demanding
    puzzle = Sudoku::Puzzle.new
    bd = [ [ 0, 0, 5,  0, 8, 0,  2, 0, 0 ],
           [ 0, 7, 2,  0, 0, 0,  0, 8, 0 ],
           [ 4, 1, 0,  3, 0, 0,  0, 0, 0 ],
           [ 0, 0, 0,  0, 0, 2,  4, 3, 0 ],
           [ 0, 0, 0,  8, 0, 9,  0, 0, 0 ],
           [ 0, 2, 0,  0, 0, 0,  0, 0, 1 ],
           [ 0, 0, 0,  0, 0, 5,  0, 7, 8 ],
           [ 5, 0, 0,  0, 0, 0,  0, 0, 6 ],
           [ 0, 6, 0,  0, 1, 7,  0, 0, 0 ] ]
    solution = [ [ 6, 9, 5,  7, 8, 4,  2, 1, 3 ],
                 [ 3, 7, 2,  5, 9, 1,  6, 8, 4 ],
                 [ 4, 1, 8,  3, 2, 6,  5, 9, 7 ],
                 [ 7, 8, 6,  1, 5, 2,  4, 3, 9 ],
                 [ 1, 5, 3,  8, 4, 9,  7, 6, 2 ],
                 [ 9, 2, 4,  6, 7, 3,  8, 5, 1 ],
                 [ 2, 3, 1,  4, 6, 5,  9, 7, 8 ],
                 [ 5, 4, 7,  9, 3, 8,  1, 2, 6 ],
                 [ 8, 6, 9,  2, 1, 7,  3, 4, 5 ] ]
    puzzle.set_board( bd )
    solver = Sudoku::Solver.new( puzzle )
    result = solver.solve
    assert_equal true, result[ :success ]
    assert_equal solution, puzzle.board
  end
  
  #-----------------------------------------------------------------------------

  def test_challenging
    puzzle = Sudoku::Puzzle.new
    bd = [ [ 0, 1, 0,  0, 0, 7,  0, 0, 0 ],
           [ 0, 0, 8,  4, 2, 0,  0, 0, 3 ],
           [ 0, 0, 0,  5, 3, 0,  0, 0, 0 ],
           [ 7, 0, 9,  0, 0, 0,  0, 0, 0 ],
           [ 0, 0, 0,  0, 0, 0,  0, 6, 1 ],
           [ 0, 0, 0,  9, 0, 0,  3, 0, 2 ],
           [ 0, 8, 0,  6, 0, 0,  0, 0, 9 ],
           [ 0, 0, 3,  0, 4, 0,  0, 0, 5 ],
           [ 0, 4, 2,  0, 0, 0,  0, 1, 0 ] ]
    solution = [ [ 3, 1, 5,  8, 9, 7,  2, 4, 6 ],
                 [ 9, 7, 8,  4, 2, 6,  1, 5, 3 ],
                 [ 4, 2, 6,  5, 3, 1,  8, 9, 7 ],
                 [ 7, 6, 9,  2, 1, 3,  5, 8, 4 ],
                 [ 2, 3, 4,  7, 8, 5,  9, 6, 1 ],
                 [ 8, 5, 1,  9, 6, 4,  3, 7, 2 ],
                 [ 1, 8, 7,  6, 5, 2,  4, 3, 9 ],
                 [ 6, 9, 3,  1, 4, 8,  7, 2, 5 ],
                 [ 5, 4, 2,  3, 7, 9,  6, 1, 8 ] ]
    puzzle.set_board( bd )
    solver = Sudoku::Solver.new( puzzle )
    result = solver.solve
    assert_equal true, result[ :success ]
    assert_equal solution, puzzle.board
  end
  
  #=============================================================================

end                                                                  #TestSolver
