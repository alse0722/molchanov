def powmod(base, exp, mod)
  result = 1
  base = base % mod
  while exp > 0
    if exp % 2 == 1
      result = (result * base) % mod
    end
    exp = exp >> 1
    base = (base * base) % mod
  end
  return result
end

def gcd(a, b)
  while b != 0
    a, b = b, a % b
  end
  return a
end

def brent_rho(n)
  if n % 2 == 0
    return 2
  end

  x = 2
  y = 2
  d = 1
  f = ->(x) { (x * x + 1) % n }

  while d == 1
    x = f.call(x)
    y = f.call(f.call(y))
    d = gcd((x - y).abs, n)
  end

  return d
end

def factorize(n)
  factors = []
  while n > 1
    factor = brent_rho(n)
    factors << factor
    n = n / factor
  end
  return factors
end

# Пример использования
number_to_factorize = 143
result = factorize(number_to_factorize)
puts "Factors of #{number_to_factorize}: #{result.join(', ')}"
