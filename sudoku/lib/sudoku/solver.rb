# solver.rb
#
# Sudoku puzzle solver
# NOTES:
# 1. solve updates the puzzle and returns whether it was successful and
#    the list of entries (blank locations and their deduced values).

require_relative 'puzzle'

module Sudoku

  #=============================================================================

  class Solver

    #---------------------------------------------------------------------------

    def initialize( puzzle )
      @puzzle = puzzle
      @t = puzzle.t
      @board = puzzle.board
      init_bookkeeping
    end
    
    #---------------------------------------------------------------------------

    def solve
      while ( @blanks.size > 0 )
        rslt = fill_a_blank
        if rslt
          if rslt[ :val ]
            @puzzle.set_cell( rslt[ :row ], rslt[ :col ], rslt[ :val ] )
            update_bookkeeping rslt
          elsif rslt[ :entries ]
            return rslt
          end
        else
          return { :success => false, :entries => @entries }
        end
      end

      return { :success => true, :entries => @entries }
    end
    
    #---------------------------------------------------------------------------

    private
    
    #---------------------------------------------------------------------------

    def init_bookkeeping
      @entries = []
      @rows = []
      @cols = []
      @blocks = []
      init_blanks
      init_groups( @rows, "row" ) { | r, c | [ r, c ] }
      init_groups( @cols, "col" ) { | c, r | [ r, c ] }
      init_groups( @blocks, "block" ) { | b, i | @puzzle.bi_rc [ b, i ] }
    end
    
    #...........................................................................

    def init_blanks
      @blanks = {}
      for r in 0...@t
        for c in 0...@t
          if @board[ r ][ c ] == 0
            @blanks[ [ r, c ] ] = {}
          end
        end
      end
    end
    
    #...........................................................................

    def init_groups( groups, type, &to_rc )
      for i in 0...@t
        group = { :vals => [] }
        for j in 0...@t
          rc = to_rc.call( i, j )
          val = @board[ rc[0] ][ rc[1] ]
          group[ :vals ] << val
        end
        init_present_missing( group, type, i )
        groups << group
      end
    end
    
    #...........................................................................

    def init_present_missing( group, type, idx )
      group[ :blanks ] = {}
      group[ :present ] = []
      group[ :missing ] = ( 1..@t ).to_a
      for j in 0...@t
        val = group[ :vals ][ j ]
        if val == 0
          group[ :blanks ][ j ] = {}
        else
          if group[ :present ].find_index( val )
            raise Sudoku::InvalidFormat, "Invalid puzzle: #{val} repeated in #{type} #{idx}"
          end
          group[ :present ].push( val )
          group[ :missing ].delete( val )
        end
      end
    end
    
    #---------------------------------------------------------------------------

    def fill_a_blank
      return solve_by_blank_possibilities ||
        solve_by_rcb_possibilities ||
        solve_by_brute_force
    end
    
    #---------------------------------------------------------------------------

    def solve_by_blank_possibilities
      get_blank_possibilities
      @blanks.each do | loc, props |
        if props[ :possible ].size == 0
          raise Sudoku::NoSolution, "No possible entry at #{loc[0]}, #{loc[1]}"
        elsif props[ :possible ].size == 1
          val = props[ :possible ].pop
          return { :row => loc[0], :col => loc[1], :val => val,
            :found_by => "blank possibilities" }
        end
      end
      return nil
    end
    
    #...........................................................................

    def get_blank_possibilities
      @blanks.each do | loc, props |
        r = loc[0]
        c = loc[1]
        b = (@puzzle.rc_bi [ r, c ])[0]
        props[ :possible ] = @rows[ r ][ :missing ] & @cols[ c ][ :missing ] &
          @blocks[ b ][ :missing ]
      end
    end
    
    #---------------------------------------------------------------------------

    def solve_by_rcb_possibilities
      return solve_group_possibilities( @rows, "row" ) { | r, c | [ r, c ] } ||
        solve_group_possibilities( @cols, "col" ) { | c, r | [ r, c ] } ||
        solve_group_possibilities( @blocks, "block" ) { | b, i | @puzzle.bi_rc [ b, i ] }
    end
    
    #...........................................................................

    def solve_group_possibilities( groups, type, &to_rc )
      for i in 0...@t
        get_group_blank_possibilities( groups, i, to_rc )
        group = groups[ i ]
        group[ :blanks ].each do | j, props |
          only_here = props[ :possible ]
          group[ :blanks ].each do | k, props |
            if k != j
              only_here = only_here - props[ :possible ]
            end
          end
          if only_here.size > 1
            raise Sudoku::NoSolution, "Too many values forced for #{type} (#{i}, #{j})"
          elsif only_here.size == 1
            rc = to_rc.call( i, j )
            r = rc[0]
            c = rc[1]
            val = only_here.pop
            return { :row => r, :col => c, :val => val,
              :found_by => "solve_group_possibilities (#{type})" }
          end
        end
      end
      return nil
    end
    
    #...........................................................................

    def get_group_blank_possibilities( groups, i, to_rc )
      groups[ i ][ :blanks ].each do | j, props |
        rc = to_rc.call( i, j )
        props[ :possible ] = @blanks[ rc ][ :possible ]
      end
    end
      
    #---------------------------------------------------------------------------

    def solve_by_brute_force
      min_len = nil
      best_blank_loc = nil
      best_blank_poss = nil
      @blanks.each do | loc, props |
        poss = props[ :possible ]
        if (min_len == nil) || (poss.size < min_len)
          best_blank_loc = loc
          best_blank_poss = poss
          min_len = props[ :possible ].size
        end
      end

      r = best_blank_loc[0]
      c = best_blank_loc[1]
      num_solutions = 0
      best_blank_poss.each do | val |
        begin
          puzzle = @puzzle.clone
          puzzle.set_cell( r, c, val )
          solver = Solver.new( puzzle )
          rslt = solver.solve
          if rslt[ :success ]
            if ++num_solutions > 1
              raise Sudoku::TooManySolutions, "Too many possibilities at #{r}, #{c}"
            end
            @entries << { :row => r, :col => c, :val => val,
              :found_by => "brute force" }
            @entries.concat rslt[ :entries ]
            @puzzle.set_board puzzle.board
            return { :success => rslt[ :success ], :entries => @entries }
          else
            # OK for all but one
          end
        rescue Sudoku::NoSolution
          # OK, expected for all but one
        end
      end
      return nil
    end
    
    #---------------------------------------------------------------------------

    def update_bookkeeping( entry )
      r = entry[ :row ]
      c = entry[ :col ]
      bi = @puzzle.rc_bi [ r, c ]
      b = bi[0]
      i = bi[1]
      val = entry[ :val ]

      @entries << entry
      @blanks.delete( [ r, c ] )
      update_group( @rows[ r ], c, val )
      update_group( @cols[ c ], r, val )
      update_group( @blocks[ b ], i, val )
    end
    
    #...........................................................................

    def update_group( group, idx, val )
      group[ :vals ][ idx ] = val
      group[ :blanks ].delete( idx )
      group[ :present ].push( val )
      group[ :missing ].delete( val )
    end
    
    #---------------------------------------------------------------------------
    
  end                                                                    #Solver
  
  #=============================================================================
  
end                                                                      #Sudoku
