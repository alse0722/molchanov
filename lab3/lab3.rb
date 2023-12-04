require "time"

def timer(f)
  lambda do |*args, **kwargs|
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    ans = f.call(*args, **kwargs)
    finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    puts "Time: #{(finish - start) * 1000}ms"
    ans
  end
end

def hlp_ferma(a, n)
  ans = 1
  (1..n-1).each do |i|
    ans = (ans * a) % n
  end
  ans = (ans - 1) % n
  ans
end

def fermat(n, k)
  k.times do
    a = rand(n - 2) + 2
    return 0 if a.gcd(n) > 1

    tmp = hlp_ferma(a, n)
    return 0 if tmp != 0
  end
  1
end

def hlp(base, e, n)
  x, y = 1, base
  while e != 0
    if e % 2 != 0
      x = (x * y) % n
    end
    y = (y * y) % n
    e = e / 2
  end
  x % n
end

def jacobi(a, n)
  return 0 if a.gcd(n) != 1

  t = 1
  a %= n
  while a != 0
    while a % 2 == 0
      a /= 2
      if n % 8 == 3 || n % 8 == 5
        t = -t
      end
    end
    n, a = a, n
    if a % 4 == 3 && n % 4 == 3
      t = -t
    end
    a %= n
  end
  t
end

def solovay_strassen(n, k)
  return false if n < 2
  return false if n != 2 && n % 2 == 0

  k.times do
    a = rand(n - 1) + 1
    jacobian = (n + jacobi(a, n)) % n
    mod = hlp(a, (n - 1) / 2, n)

    if jacobian == 0 || mod != jacobian
      return false
    end
  end
  true
end

def miller_rabin(n)
  return 1 if n == 2 || n == 3
  return 0 if n.even? && n != 1

  s, t, x = 0, n - 1, 0
  r1, r2 = 2, n - 2
  a, r = Math.log2(n).to_i, Math.log2(n).to_i

  while t != 0 && t % 2 == 0
    s += 1
    t /= 2
  end

  r.times do
    a = r1 + rand(r2 - r1)
    x, j = 1, 1

    while j <= t
      x = (x * a) % n
      j += 1
    end

    next if x == 1 || x == n - 1

    (s - 1).times do
      x = (x * x) % n
      return 0 if x == 1
      break if x == n - 1
    end

    return false if x != n - 1
  end
  true
end

def miller_rabin_prime(n, g = 50)
  return false if n == 1

  # puts "[debug] Miller-Rabin test for #{n} (#{g} rounds)" if @debug_mode == :all

  d = n - 1
  s = 0

  while d % 2 == 0
    d /= 2
    s += 1
  end

  g.times do

    if n == 4 
      a = 2
    else
      a = 2 + rand(n - 4)
    end

    x = a.pow(d, n)
    
    next if x == 1 || x == n - 1
    
    for r in (1..s - 1)
      x = x.pow(2, n)
        if x == 1
          puts "\tNumber #{n} is not prime!\n" if @debug_mode == :all
          return false 
        end
      break if x == n - 1
    end

    if x != n - 1
      puts "\tNumber #{n} is not prime!\n" if @debug_mode == :all
      return false
    end
  end

  # if @debug_mode == :all
  #   puts "\tNumber #{n} is prime!\n" 
  # elsif @debug_mode == :default
  #   puts "Miller-Rabin test for #{n}: is probably prime!"
  # end

  true
end

def miller_test(d, n)
  a = 2 + rand(n - 4)
  x = a
  (d - 1).times do
    x = (x * a) % n
  end

  return true if x == 1 || x == n - 1

  while d != n - 1
    x = (x * x) % n
    d *= 2
    return false if x == 1
    return true if x == n - 1
  end

  false
end

def rabin_miller(n, k)
  # puts "\nПроверка на простоту с помощью теста Рабина-Миллера: "
  if n <= 1 || n == 4
    # puts "n - составное число"
    return false
  end

  if n <= 3
    # puts "Число #{n}, вероятно, простое"
    return true
  end

  if n.even?
    # puts "n - составное число"
    return false
  end

  d = n - 1
  d /= 2 while d.even?

  k.times do
    unless miller_test(d, n)
      # puts "n - составное число"
      return false
    end
  end

  # puts "Число #{n}, вероятно, простое"
  true
end

# Пример использования
rabin_miller(101, 5)


def main

  opt = 1

  while opt != 0
    puts "\nВыберите действие"
    puts "0 - Выход из программы"
    puts "1 - Проверка тестом Ферма"
    puts "2 - Проверка тестом Соловея-Штрассена"
    puts "3 - Проверка тестом Миллера-Рабина"
    puts "4 - Все тесты"
    opt = gets.strip.to_i
    
    break if opt == 0

    puts "\nВведите число для проверки на простоту"
    n = gets.strip.to_i

    if opt == 1 || opt == 2 || opt == 4
      puts "\nВведите число проверок"
      k = gets.strip.to_i
    end

    case opt
    when 1
      r = fermat(n, k)
      if r == 0
        puts "\nРезультат проверки тестом Ферма: Составное"
      else
        puts "\nРезультат проверки тестом Ферма: Вероятно простое"
      end
    when 2
      r = solovay_strassen(n, k)
      if !r
        puts "\nРезультат проверки тестом Соловея-Штрассена: Составное"
      else
        puts "\nРезультат проверки тестом Соловея-Штрассена: Вероятно простое"
      end
    when 3
      r = miller_rabin(n)
      if !r
        puts "\nРезультат проверки тестом Миллера-Рабина: Составное"
      else
        puts "\nРезультат проверки тестом Миллера-Рабина: Вероятно простое"
      end
    when 4
      r = fermat(n, k)
      if r == 0
        puts "\nРезультат проверки тестом Ферма: Составное"
      else
        puts "\nРезультат проверки тестом Ферма: Вероятно простое"
      end

      r = solovay_strassen(n, k)
      if !r
        puts "\nРезультат проверки тестом Соловея-Штрассена: Составное"
      else
        puts "\nРезультат проверки тестом Соловея-Штрассена: Вероятно простое"
      end

      r = rabin_miller(n, k)
      if !r
        puts "\nРезультат проверки тестом Миллера-Рабина: Составное"
      else
        puts "\nРезультат проверки тестом Миллера-Рабина: Вероятно простое"
      end

    end
  end
end

if __FILE__ == $PROGRAM_NAME
  main
end
