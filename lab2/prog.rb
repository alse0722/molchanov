def chain(a_1, a_2)
  q = []
  while (a_1 % a_2 != 0)
    q << (a_1 / a_2).to_i
    a_1 %= a_2
    a_1, a_2 = a_2, a_1
  end
  q << (a_1 / a_2).to_i
  return q
end

def euclid_extended(a, b)
  if a == 0
    return b, 0, 1
  end
  gcd, x1, y1 = euclid_extended(b % a, a)
  x = y1 - (b / a) * x1
  y = x1
  return gcd, x, y
end

def modular_multiplicative_inverse(a, m)
  g, x, _ = euclid_extended(a, m)
  if g != 1
    return nil
  else
    return (x % m + m) % m
  end
end

def diophantus(a, b, c)
  gcd, x, y = euclid_extended(a, b)
  p, q = [0, 1], [1, 0]
  q_chain = chain(a, b)

  q_chain.each do |q_i|
    p << q_i * p[-1] + p[-2]
    q << q_i * q[-1] + q[-2]
  end

  p = p[2..-1]
  q = q[2..-1]

  if c % gcd == 0
    k = p.length
    a /= gcd
    b /= gcd
    c /= gcd
    x = (-1) ** k * q[-2] * c + b
    y = -1 * ((-1) ** k * p[-2] * c + a)
    return x, y
  end
end

def linear_comparison(a, b, m)
  x, _ = diophantus(a, m, b)
  x %= m
  return x
end

def legendre(a, p)
  if a == 1
    return 1
  end

  b = a % p
  if b > p / 2
    b -= p
  end

  if b > 0
    t = 2
  else
    t = 1
  end

  b = -b
  k = 0

  while b % 2 == 0
    b /= 2
    k += 1
  end

  c = b
  t_1 = 1

  if t % 2 == 1
    t_1 = (-1) ** ((p - 1) / 2)
  end

  k_1 = 1

  if k % 2 == 1
    k_1 = (-1) ** ((p * p - 1) / 8)
  end

  if c == 1
    return t_1 * k_1
  end

  return t_1 * k_1 * (-1) ** (((c - 1) / 2) * ((p - 1) / 2)) * legendre(p, c)
end

def jacobi(a, p)
  if euclid_extended(a, p)[0] != 1
    return 0
  end

  r = 0
  t = 1
  a = a % p

  while a != 0
    while a % 2 == 0
      a /= 2
    end

    if p % 8 == 3 || p % 8 == 5
      t = -t
    end

    r = p
    p = a
    a = r

    if a % 4 == 3 && p % 4 == 3
      t = -t
    end

    a = a % p

    if p == 1
      return t
    end
  end
end

def min_k(a, p, q)
  k = 0
  while (a ** (2 ** k * q)) % p != 1
    k += 1
  end
  return k
end

def sqrt(a, p)
  q = p - 1
  m = 0

  while q % 2 == 0
    q /= 2
    m += 1
  end

  b = rand(1..p)

  while legendre(b, p) != -1
    b = rand(1..p)
  end

  _as = [a]
  ks = [min_k(a, p, q)]
  k = ks[0]

  while k != 0
    a = (a * b ** (2 ** (m - k))) % p
    k = min_k(a, p, q)
    _as << a
    ks << k
  end

  rs = []
  r = (_as[-1] ** ((q + 1) / 2)) % p
  rs << r

  for i in 0.._as.length - 2
    bc = b ** (2 ** (m - ks[-i - 2] - 1))
    r = (rs[i] * modular_multiplicative_inverse(bc, p)) % p
    rs << r
  end

  return rs[0]
end

def sqrt2(a, p)
  
  b = rand(1..p)

end

def main
  puts "0\n1 \n2\n3\n4\n5\n6\n"
  opt = gets.chomp

  case opt
  when '0'
    puts "Numerator of fraction = "
    m, n = gets.chomp.to_i, gets.chomp.to_i
    puts "Continued fraction expansion =", chain(m, n)

  when '1'
    puts "Number a = "
    m, n, c = gets.chomp.to_i, gets.chomp.to_i, gets.chomp.to_i
    puts "Solution of the Diaphantine equation =", diophantus(m, n, c)

  when '2'
    puts "Number a = "
    a, m = gets.chomp.to_i, gets.chomp.to_i
    puts "Inverse element modulo a given =", modular_multiplicative_inverse(a, m)

  when '3'
    puts "Number a = "
    m, n, c = gets.chomp.to_i, gets.chomp.to_i, gets.chomp.to_i
    puts "Linear Comparison Solution =", diophantus(m, c, n)[0] % c

  when '4'
    puts "Number a = "
    a, n = gets.chomp.to_i, gets.chomp.to_i
    puts "Legendre's symbol = ", legendre(a, n)
    puts "Jacobi symbol = ", jacobi(a, n)

  when '5'
    puts "Number a = "
    a, p = gets.chomp.to_i, gets.chomp.to_i
    puts "Square root of a modulo p =", sqrt(a, p)

  when '6'
    exit
  end
end

main
