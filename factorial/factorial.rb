#!/usr/bin/env ruby
# factorial.rb
#
# Iterative implementation of factorial function (x!).

def factorial x
  if x > 0
    return (1..x).inject(1) { |fact, n|  n * fact }
  elsif x == 0
    return 1
  else
    return nil
  end
end


if ARGV.size > 0
  x = ARGV[0].to_i
  puts factorial x
else
  puts "I need a number."
end
