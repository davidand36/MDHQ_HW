# test_puzzle.rb
#
# Tests for Sudoku::Puzzle

require 'test/unit'
require 'stringio'
require_relative '../lib/sudoku/exception'
require_relative '../lib/sudoku/puzzle'

class TestPuzzle < Test::Unit::TestCase

  #=============================================================================

  def setup
    @puzzle = Sudoku::Puzzle.new( 2, 3 )
    @bd = [ [ 3, 0, 0, 0, 0, 4 ],
            [ 0, 2, 6, 5, 1, 0 ],
            [ 2, 6, 4, 3, 5, 1 ],
            [ 1, 0, 0, 0, 0, 2 ],
            [ 0, 4, 1, 2, 3, 0 ],
            [ 6, 0, 0, 0, 0, 5 ] ]
    @csv = <<END
3,-,-,-,-,4
-,2,6,5,1,-
2,6,4,3,5,1
1,-,-,-,-,2
-,4,1,2,3,-
6,-,-,-,-,5
END
  end
  
  #-----------------------------------------------------------------------------

  def test_dims
    assert_equal 2, @puzzle.m
    assert_equal 3, @puzzle.n
    assert_equal 6, @puzzle.t
  end

  #-----------------------------------------------------------------------------

  def test_set_board
    @puzzle.set_board( @bd )
    assert_equal 5, @puzzle.board[ 2 ][ 4 ]
    assert_equal 0, @puzzle.board[ 5 ][ 2 ]

    bd = [ [ 3, 0, 0, 0, 0, 4 ],
           [ 0, 2, 6, 5, 1, 0 ],
           [ 2, 6, 4, 3, 5, 1 ],
           [ 0, 4, 1, 2, 3, 0 ],
           [ 6, 0, 0, 0, 0, 5 ] ]
    assert_raises( Sudoku::InvalidFormat ) { @puzzle.set_board( bd ) }

    bd = [ [ 3, 0, 0, 0, 0, 4 ],
           [ 0, 2, 6, 5, 1, 0 ],
           [ 2, 6, 4, 3, 5, 1, 1 ],
           [ 1, 0, 0, 0, 0, 2 ],
           [ 0, 4, 1, 2, 3, 0 ],
           [ 6, 0, 0, 0, 0, 5 ] ]
    assert_raises( Sudoku::InvalidFormat ) { @puzzle.set_board( bd ) }
  end
  
  #-----------------------------------------------------------------------------

  def test_read_csv
    csv_file = StringIO.new( @csv )
    @puzzle.read_csv( csv_file )
    assert_equal 5, @puzzle.board[ 2 ][ 4 ]
    assert_equal 0, @puzzle.board[ 5 ][ 2 ]
  end
  
  #-----------------------------------------------------------------------------

  def test_write_csv
    @puzzle.set_board( @bd )
    csv_file = StringIO.new( "", "w" )
    @puzzle.write_csv( csv_file )
    assert_equal @csv, csv_file.string
  end
  
  #-----------------------------------------------------------------------------

  def test_write_txt
    @puzzle.set_board( @bd )
    txt_file = StringIO.new( "", "w" )
    @puzzle.write_txt( txt_file )
    txt = <<END
3-- --4 
-26 51- 

264 351 
1-- --2 

-41 23- 
6-- --5 

END
    assert_equal txt, txt_file.string
  end
  
  #-----------------------------------------------------------------------------

  def test_set_cell
    @puzzle.set_board( @bd )
    assert_equal 0, @puzzle.board[ 4 ][ 0 ]
    @puzzle.set_cell( 4, 0, 5 )
    assert_equal 5, @puzzle.board[ 4 ][ 0 ]
  end
  
  #-----------------------------------------------------------------------------

  def test_clone
    @puzzle.set_board( @bd )
    puzzle = @puzzle.clone
    assert_equal 0, @puzzle.board[ 4 ][ 0 ]
    assert_equal 0, puzzle.board[ 4 ][ 0 ]
    puzzle.set_cell( 4, 0, 5 )
    assert_equal 0, @puzzle.board[ 4 ][ 0 ]
    assert_equal 5, puzzle.board[ 4 ][ 0 ]
  end
  
  #-----------------------------------------------------------------------------

  def test_bi_rc
    rc = @puzzle.bi_rc( [ 0, 2 ] )
    assert_equal 0, rc[ 0 ]
    assert_equal 2, rc[ 1 ]
    rc = @puzzle.bi_rc( [ 3, 2 ] )
    assert_equal 2, rc[ 0 ]
    assert_equal 5, rc[ 1 ]
    bi = @puzzle.rc_bi( [ 2, 5 ] )
    assert_equal 3, bi[ 0 ]
    assert_equal 2, bi[ 1 ]
    rc = @puzzle.bi_rc( [ 4, 5 ] )
    assert_equal 5, rc[ 0 ]
    assert_equal 2, rc[ 1 ]
    bi = @puzzle.rc_bi( [ 5, 2 ] )
    assert_equal 4, bi[ 0 ]
    assert_equal 5, bi[ 1 ]
  end
  
  #=============================================================================

end                                                                  #TestPuzzle
