require './methods.rb'

puts %{Enable debug? y/n}
@debug_mode = gets.strip == 'y'
@methods = Methods.new({debug_mode: @debug_mode})

def many_gcds
  puts %{Enter a, b:}
  a, b = gets.strip.split.map(&:to_i)
  puts %{Default: gcd(#{a}, #{b}) = #{@methods.gcd(a, b)}}
  puts %{Binary:  gcd(#{a}, #{b}) = #{@methods.gcd_bin(a, b)}}
  res = @methods.gcd_ext(a, b)
  puts %{Default: gcd(#{a}, #{b}) = #{res[0]}, x = #{res[1]}, y = #{res[2]}}
end

def solve_comparation_system
  puts %{Solving comparation system!}

  equations = []
  coefficients = []
  modulus = []

  puts %{Enter count of equations in system:}
  n = gets.strip.to_i

  puts %{Enter equations:}
  n.times do 
    equation = gets.strip.split.map(&:to_i)
    a, b = equation[0], equation[1]
    equations.append(%{x = #{a} (mod #{b})})
    coefficients.append(a)
    modulus.append(b)
  end

  #debug
  if @debug_mode
    puts %{equations:}
    equations.map {|eq| puts eq}
    puts %{coefficients: #{coefficients}}
    puts %{modulus: #{modulus}}
  end

  puts %{Result: #{@methods.chineese_reminder_theorem(coefficients, modulus)}}

end

def solve_gauss_system
  puts %{Solving equation's system by Gauss method!}

  matrix = []

  puts %{Enter count of equations in system:}
  n = gets.strip.to_i

  puts %{Enter equations:}
  n.times do
    matrix << gets.split.map(&:to_i)
  end

  puts %{Enter module:}
  field_dimension = gets.to_i

  puts %{Result: #{@methods.gauss(matrix, field_dimension)}}

end

#1
#many_gcds

#2
# solve_comparation_system

#3
solve_gauss_system

#tests
# puts @methods.inverse(5, 10)