# puzzle.rb
#
# Represents a Sudoku puzzle
# NOTES:
# 1. The board is a TxT two-dimensional array ([row][column]) of cells,
#    also regarded as an MxN array of NxM blocks of cells. M*N = T.
# 2. Internally cells are integers from 1 to T, with blanks represented by 0.
#    An array of strings--the "alphabet"--is used for display.
# 3. While it is trivial to obtain the elements of a row or column from the
#    board, obtaining the elements of a block is less so. The method
#    bi_rc converts between a two-element array representing [ row, col ]
#    and one representing [ block, index ]. It turns out that the math is the
#    same going either way, so there is just one method.

require_relative 'exception'

module Sudoku

  #=============================================================================

  class Puzzle

    #---------------------------------------------------------------------------

    attr_reader  :m, :n, :t
    attr_reader  :board
    
    #---------------------------------------------------------------------------

    def initialize( m = 3, n = 3,
                    alphabet = %w{ - 1 2 3 4 5 6 7 8 9 } )
      @m = m
      @n = n
      @t = @m * @n
      @alphabet = alphabet
    end
    
    #---------------------------------------------------------------------------

    def initialize_copy( source )
      if source.board
        @board = []
        source.board.each { |row| @board << row.dup }
      end
    end
    
    #---------------------------------------------------------------------------

    def set_board( board )
      @board = board
      validate_board_size
    end
    
    #---------------------------------------------------------------------------

    def read_csv( file = $stdin )
      board = []
      file.each_line do | line |
        row = line.chomp.split( ',' )
        row.collect! { |e| @alphabet.index( e ) || 0 }
        board << row
      end
      set_board board 
    end
    
    #---------------------------------------------------------------------------

    def validate_board_size
      if @board.size != @t
        raise Sudoku::InvalidFormat, "Wrong number of board rows: expected #{@t}, found #{@board.size}"
      end
      @board.each do | row |
        if row.size != @t
          raise Sudoku::InvalidFormat, "Wrong number of board columns: expected #{@t}, found #{row.size}"
        end
      end
    end
    
    #---------------------------------------------------------------------------

    def write_csv( file = $stdout )
      @board.each do | row |
        file.puts( (row.collect { |e| @alphabet[ e ] }).join( ',' ) )
      end
    end
    
    #---------------------------------------------------------------------------

    def write_txt( file = $stdout )
      for y in (0...@n)
        for r in (0...@m)
          for x in (0...@m)
            for c in (0...@n)
              i = y * @m  +  r
              j = x * @n  +  c
              file.print @alphabet[ @board[i][j] ]
            end
            file.print ' '
          end
          file.puts
        end
        file.puts
      end
    end
    
    #---------------------------------------------------------------------------

    def set_cell( row, col, value )
      @board[ row ][ col ] = value
    end
    
    #---------------------------------------------------------------------------

    def bi_rc( loc )
      aq, ar = loc[ 0 ].divmod( @m )
      bq, br = loc[ 1 ].divmod( @n )
      return[ aq * @m  +  bq,  ar * @n  +  br ]
    end

    alias rc_bi bi_rc
    
    #---------------------------------------------------------------------------
    
  end                                                                    #Puzzle
  
  #=============================================================================
  
end                                                                      #Sudoku
