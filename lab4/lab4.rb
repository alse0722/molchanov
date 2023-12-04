require 'prime'
require 'matrix'

class PollardMethod
  def initialize(n, eps)
    raise ArgumentError, 'eps должен быть в пределах от 0 до 1' unless eps > 0 && eps < 1
    @n = n
    @eps = eps
  end

  def factorize
    return "#{@n} = 1 * #{@n}" if @n == 1
    return "#{@n} = #{@n}" if Prime.prime?(@n)

    x = 2
    y = 2
    d = 1

    f = proc { |z| (z**2 + 1) % @n }

    while d == 1
      x = f.call(x)
      y = f.call(f.call(y))
      d = (x - y).gcd(@n)
    end

    if d == @n
      return "Не удалось разложить число #{@n}."
    else
      q = @n / d
      return "#{@n} = #{d} * #{q}"
    end
  end
end

class PollardMethod2
  def initialize(n, eps)
    raise ArgumentError, 'eps должен быть в пределах от 0 до 1' unless eps > 0 && eps < 1
    @n = n
    @eps = eps
  end

  def factorize
    return [1] if @n == 1
    return [1, @n] if Prime.prime?(@n)

    factors = []

    f = proc { |z| (z**2 + 1) % @n }

    x = 2
    y = 2
    d = 1

    while d == 1
      x = f.call(x)
      y = f.call(f.call(y))
      d = (x - y).gcd(@n)
    end

    if d == @n
      factors << "Не удалось разложить число #{@n}."
    else
      q = @n / d
      factors.concat(factorize_helper(d))
      factors.concat(factorize_helper(q))
    end

    factors
  end

  private

  def factorize_helper(num)
    if Prime.prime?(num)
      [num]
    else
      PollardMethod.new(num, @eps).factorize
    end
  end
end

# class PollardMethodPMinusOne
#   def initialize(n, b)
#     @n = n
#     @b = b
#     @t = 1
#   end

#   def generate_base
#     base = []
#     Prime.each(@b) do |p|
#       base << p
#       k = (Math.log(@n) / Math.log(p)).to_i
#       @t *= p**k
#     end
#     base
#   end

#   def factorize
#     generate_base

#     factors = []

#     loop do
#       a = rand(1..@n)
#       d = a.gcd(@n)

#       if d > 1 && d < @n
#         factors << d
#         factors << @n / d
#         return factors.uniq.sort
#       end

#       if d == 1
#         b = a.pow(@t, @n) - 1
#         n1 = b.gcd(@n)

#         if n1 == 1
#           # Increase factor base
#           generate_base
#           next
#         elsif n1 == @n
#           # Decrease factor base
#           generate_base
#           next
#         else
#           factors << n1
#           factors << @n / n1
#           return factors.uniq.sort
#         end
#       end
#     end
#   end
# end

class PollardMethodPMinusOne
  def initialize(n, b)
    @n = n
    @b = b
    @t = 1
  end

  def generate_base
    base = []
    Prime.each(@b) do |p|
      base << p
      k = (Math.log(@n) / Math.log(p)).to_i
      @t *= p**k
    end
    base
  end

  def factorize_number(number)
    factors = []
    d = 2

    while d <= number
      if (number % d).zero?
        factors << d
        number /= d
      else
        d += 1
      end
    end

    factors
  end

  def factorize
    generate_base

    factors = []

    loop do
      a = rand(1..@n)
      d = a.gcd(@n)

      if d > 1 && d < @n
        factors.concat(factorize_number(d))
        factors.concat(factorize_number(@n / d))
        return factors.uniq.sort
      end

      if d == 1
        b = a.pow(@t, @n) - 1
        n1 = b.gcd(@n)

        if n1 == 1
          # Increase factor base
          generate_base
          next
        elsif n1 == @n
          # Decrease factor base
          generate_base
          next
        else
          factors.concat(factorize_number(n1))
          factors.concat(factorize_number(@n / n1))
          return factors.uniq.sort
        end
      end
    end
  end
end

# class BrillhartMorrisonFactorization
#   attr_accessor :n, :a

#   def initialize(n, a)
#     @n = n
#     @a = a
#   end

#   def factorize
#     puts "Исходное число: #{n}"

#     # Шаг 1: Вычисление L
#     l = Math.exp((Math.log(n) * Math.log(Math.log(n)))**a).to_i
#     puts "L = #{l}"

#     # Шаг 2: Генерация факторной базы
#     factor_base = [-1] + Prime.each(l).select { |pi| jacobi(pi, n) != -1 }
#     puts "Факторная база: #{factor_base}"

#     loop do
#       x, y = solve_linear_system(factor_base)
#       break if x.empty?

#       gcd1 = gcd(x + y, n)
#       gcd2 = gcd(x - y, n)

#       if gcd1 > 1 && gcd1 < n
#         puts "Найден нетривиальный делитель: #{gcd1}"
#         puts "Факторизация: #{gcd1} * #{n / gcd1}"
#         break
#       elsif gcd2 > 1 && gcd2 < n
#         puts "Найден нетривиальный делитель: #{gcd2}"
#         puts "Факторизация: #{gcd2} * #{n / gcd2}"
#         break
#       else
#         factor_base += Prime.each(l).select { |pi| jacobi(pi, n) != -1 && !factor_base.include?(pi) }
#         puts "Увеличение факторной базы: #{factor_base}"
#       end
#     end
#   end

#   private

#   def legendre_symbol(a, p)
#     return 1 if a == 1
#     return -1 if a % 2 == 0 && (p % 8 == 3 || p % 8 == 5)
#     return legendre_symbol(p % a, a) * -1 if a % 4 == 3 && p % 4 == 3
#     return legendre_symbol(p, a) if a % 2 == 1
#     return 0 if a == 0 # Условие выхода из рекурсии
#   end

#   def legendre_symbol(a, p)
#     return 1 if a == 1
#     return -1 if a % 2 == 0 && (p % 8 == 3 || p % 8 == 5)
#     return legendre_symbol(p % a, a) * -1 if a % 4 == 3 && p % 4 == 3
#     return legendre_symbol(p, a) if a % 2 == 1
#     return 0 if a == 0 # Условие выхода из рекурсии
#   end

#   def solve_linear_system(factor_base)
#     k = factor_base.size
#     matrix_a = Matrix.build(k, k + 1) { rand(2) }

#     k.times do |i|
#       max_row = (i...k).max_by { |row| matrix_a[row, i].abs }
#       tmp = matrix_a[i, 0..k].to_a
#       matrix_a[i, 0..k] = matrix_a[max_row, 0..k]
#       matrix_a[max_row, 0..k] = tmp
#       pivot = matrix_a[i, i]

#       (i + 1...k).each do |j|
#         puts matrix_a[j, i]
#         factor = matrix_a[j, i] / pivot
#         matrix_a[j, 0..k] -= factor * matrix_a[i, 0..k]
#       end
#     end

#     x = Array.new(k, 0)
#     y = Array.new(k, 0)

#     (k - 1).downto(0) do |i|
#       y[i] = matrix_a[i, k]
#       (i + 1...k).each { |j| y[i] -= matrix_a[i, j] * y[j] }

#       x[i] = y[i] % 2
#     end

#     return x, y
#   end

#   def gcd(a, b)
#     while b != 0
#       a, b = b, a % b
#     end
#     return a
#   end

#   def jacobi(a, n)
#     return 0 if a.gcd(n) != 1
  
#     t = 1
#     a %= n
#     while a != 0
#       while a % 2 == 0
#         a /= 2
#         if n % 8 == 3 || n % 8 == 5
#           t = -t
#         end
#       end
#       n, a = a, n
#       if a % 4 == 3 && n % 4 == 3
#         t = -t
#       end
#       a %= n
#     end
#     t
#   end
# end

# Пример использования:
def get_pollard_p
  puts "\nФакторизация p-методом Полларда"
  puts "Введите n:"
  n = gets.strip.to_i
  puts "Введите параметр eps (0 < eps < 1):"
  eps = gets.strip.to_f

  pollard = PollardMethod.new(n, eps)
  puts "Результат:\n#{pollard.factorize}"
end

def get_pollard_p_2
  puts "\nФакторизация (p-1)-методом Полларда"
  puts "Введите n:"
  n = gets.strip.to_i
  puts "Введите параметр B:"
  b = gets.strip.to_i
  pollard = PollardMethodPMinusOne.new(n, b)
  result = pollard.factorize

  puts "Результат: #{n} = #{result.map(&:to_s).join(" * ")}"
end

def get_brimor
  puts "\nФакторизация методом цепных дробей"
  puts "Введите n:"
  n = gets.strip.to_i
  puts "Введите параметр a:"
  a = gets.strip.to_f
  factorizer = BrillhartMorrisonFactorization.new(n, a)
  factorizer.factorize
end

get_pollard_p
get_pollard_p
get_pollard_p_2
get_pollard_p_2
# get_brimor