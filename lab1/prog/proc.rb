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
  puts %{Extended: gcd(#{a}, #{b}) = #{res[0]}, x = #{res[1]}, y = #{res[2]}}
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

  res = @methods.chineese_reminder_theorem(coefficients, modulus)

  puts %{Result: #{res[:x]} (mod #{res[:md]})}

end

def solve_gauss_system
  puts "\n[GAUSS] Enter field (p):"
  field = gets.chomp.to_i

  puts "\n[GAUSS] Enter the number of rows and columns of the system matrix:"
  rows, cols = gets.chomp.split.map(&:to_i)

  puts "\n[GAUSS] Enter the system matrix:"
  matrix = []
  rows.times do
    row = gets.chomp.split.map(&:to_i)
    matrix << row
  end

  triangular, status = @methods.gauss(matrix, field)
  puts "\n[GAUSS] Triangular matrix: "
  @methods.get_matrix(matrix)
  @methods.get_ans([matrix, status], field)
end

#1
# many_gcds

#2
# solve_comparation_system

#3
solve_gauss_system
