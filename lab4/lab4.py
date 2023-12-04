require 'prime'

def timer
  start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  yield
  elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
  puts "Time: #{elapsed * 1000:.3f}ms"
end

def miller_rabin(p, k)
  s, m, i = p - 1, 0, 0
  while s.even?
    s /= 2
    m += 1
  end

  while i < k + 1
    a = rand(2..p - 2)
    a = rand(2..p - 2) while a.gcd(p) != 1
    b = a.pow(s, p)

    if b == 1
      next
    elsif b == p - 1
      i += 1
      next
    end

    flag = false
    (1...m).each do |l|
      c = a.pow(s * 2**l, p)
      if c == p - 1
        flag = true
        break
      end
    end

    return false unless flag

    i += 1
  end

  true
end

def poly(coef, x)
  coef.each_with_index.sum { |c, n| c * x**n }
end

def p_pollard(n, f, e)
  t = (2 * Math.sqrt(n) * Math.log10(1 / e)).to_i + 1
  a = rand(1..n)
  x, i = [], 0

  while i < t
    a = poly(f, a) % n
    x.push(a)

    (0...i).each do |k|
      d = (x[i] - x[k]) % n.gcd(n)

      if d == 1
        next
      elsif 1 < d && d < n
        return d
      elsif d == n
        return nil
      end
    end

    i += 1
  end
end

def main1
  print 'Введите число n = '
  n = gets.to_i

  if n < 0
    puts 'Неверное n'
    return
  end

  print 'Введите e: '
  e = gets.to_f

  if e < 0 || e > 1
    puts 'Неверное e'
    return
  end

  print 'Введите коэфициенты f: '
  f = gets.split.map(&:to_i).reverse
  p = p_pollard(n, f, e)

  if p
    puts "Нетривиальный делитель #{p} числа #{n}"
  else
    puts 'Делитель не найден'
  end
end

def p_1_pollard(n)
  p, x = [], 2

  while p.length < 3 && x < n
    p.push(x) if x < 4 || (x.odd? && miller_rabin(x, 5))
    x += 1
  end

  a = rand(2..n - 2)
  d = a.gcd(n)

  return d if d > 3

  p.each do |i|
    l = (Math.log(n) / Math.log(i)).to_i
    a = a.pow(i**l, n)
  end

  d = (a - 1).gcd(n)

  return nil if d == 1 || d == n

  d
end

def main2
  print 'Введите n: '
  n = gets.to_i

  if n < 0
    puts 'Неверное n'
    return
  end

  p = p_1_pollard(n)

  if p
    puts "Нетривиальный делитель #{p} числа #{n}"
  else
    puts 'Делитель не найден'
  end
end

puts <<-MENU
Выберите режим:
  1 - p-метод Полларада
  2 - (p-1)-метод Полларада
MENU

var = gets.to_i
if var == 1
  timer { main1 }
elsif var == 2
  timer { main2 }
else
  puts 'Некорректный выбор режима.'
end
