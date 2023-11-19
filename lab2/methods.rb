require 'prime'
# require 'math'

class Methods

  def initialize
  end

  def make_chain(a,b)
    q = []

    while a % b != 0
      q << (a / b).to_i
      a %= b
      a, b = b, a
    end
    
    q << (a / b).to_i

    return q
  end

  def diophantus(a, b, c)
    gcd, x, y = exea(a, b)
    p, q = [0, 1], [1, 0]
    q_chain = make_chain(a, b)
  
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

  def inv_mod(a, m)
    g, x, _ = exea(a, m)

    if g != 1
      return nil
    else
      return (x % m + m) % m
    end
  end

  def jacobi1(a, p)
    return 0 if exea(a, p)[0] != 1

    r = 0
    t = 1
    a = a % p

    while a != 0
      while a % 2 == 0
        a /= 2
      end
  
      t = -t if p % 8 == 3 || p % 8 == 5
  
      r = p
      p = a
      a = r
  
      t = -t if a % 4 == 3 && p % 4 == 3
  
      a = a % p
  
      return t if p == 1
    end
  end

  def sqrt(a, p)
    q = p - 1
    m = 0
  
    while q % 2 == 0
      q /= 2
      m += 1
    end
    
    if jacobi_symbol(a, p) != 1
      puts "Нет решения! a / p != 1"
      return nil
    end

    if q.gcd(2) != 1
      puts "Нет решения! НОД(2, q) != 1"
      return nil
    end

    b = rand(1..p)
  
    while legendre_symbol(b, p) != -1
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
      r = (rs[i] * inv_mod(bc, p)) % p
      rs << r
    end
  
    return rs[0]
  end

  def sqrt2(a, p)

    if a == 0
      return 0
    end

    y = 0
    while y < p && (y ** 2) % p != a % p
      y = y + 1
    end
    
    return y
  end

  def jacobi(a, n)
    if n < 3 || n % 2 == 0
      puts "Нет решения! p должно быть нечетным и больше 2"
      return nil
    end
  
    a = a % n
  
    t = 1
  
    while a != 0
      while a % 2 == 0
        a /= 2
        r = n % 8
        if r == 3 || r == 5
          t = -t
        end
      end
  
      a, n = n, a
      if a % 4 == 3 && n % 4 == 3
        t = -t
      end
  
      a %= n
    end
  
    if n == 1
      return t
    else
      return 0
    end
  end

  def lezhandr1(a, p)

    return 0 if !p.prime?

    if a == 0
      return 0
    elsif a == 1
      return 1
    elsif a.even?
      return lezhandr(a / 2, p) * ((p * p - 1) / 8) % 2 == 1 ? 1 : -1
    else
      return lezhandr(p % a, a) * (-1) ** ((a - 1) * (p - 1) / 4)
    end
  end

  def lezhandr(a, p)
    return 1 if a == 1
    
    # return 0 if !p.prime?

    b = a % p
    b -= p if b > p / 2

    t = b > 0 ? 2 : 1

    b = -b
    k = 0

    while b % 2 == 0
      b /= 2
      k += 1
    end

    c = b
    t_1 = 1

    t_1 = (-1) ** ((p - 1) / 2) if t % 2 == 1
    k_1 = 1
    k_1 = (-1) ** ((p * p - 1) / 8) if k % 2 == 1

    return t_1 * k_1 if c == 1
    return t_1 * k_1 * (-1) ** (((c - 1) / 2) * ((p - 1) / 2)) * lezhandr(p, c)
  end

  # Метод для вычисления символа Лежандра (a/p)
  def legendre_symbol(a, p)
    if a % p == 0
      return 0
    elsif a == 1
      return 1
    elsif a == 2
      return (p % 8 == 1 || p % 8 == 7) ? 1 : -1
    elsif a % 2 == 0
      return (legendre_symbol(2, p) * legendre_symbol(a / 2, p) * ((p**2 - 1) / 8)) % 2 == 0 ? 1 : -1
    else
      return (legendre_symbol(p % a, a) * ((a - 1) * (p - 1) / 4)) % 2 == 0 ? 1 : -1
    end
  end

  # Метод для вычисления символа Якоби (a/n)
  def jacobi_symbol(a, n)
    if n <= 0 || n % 2 == 0
      raise ArgumentError, "n должно быть нечетным и положительным"
    end

    a %= n
    t = 1

    while a != 0
      while a % 2 == 0
        a /= 2
        r = n % 8
        if r == 3 || r == 5
          t = -t
        end
      end

      a, n = n, a

      if a % 4 == 3 && n % 4 == 3
        t = -t
      end

      a %= n
    end

    if n == 1
      return t
    else
      return 0
    end
  end



  private

  def exea(a, b)
    if a == 0
      return b, 0, 1
    end
    
    gcd, x1, y1 = exea(b % a, a)
    x = y1 - (b / a) * x1
    y = x1

    return gcd, x, y
  end

  def linear_comparison(a, b, m)
    x, _ = diophantus(a, m, b)
    x %= m
    return x
  end

  def min_k(a, p, q)
    k = 0

    while (a ** (2 ** k * q)) % p != 1
      k += 1
    end

    return k
  end
end


