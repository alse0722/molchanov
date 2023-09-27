class Methods
  def initialize(params = {})
    @debug_mode = params.dig(:debug_mode)
  end

  def gcd(a,b)
    puts "using default gcd(#{a}, #{b})" if @debug_mode
    while b != 0
      remainder = a % b
      a = b
      b = remainder
      #debug
      sleep 0.5 if @debug_mode 
      puts "gcd(#{a}, #{b})" if @debug_mode
    end

    return a 
  end

  def gcd_bin(a,b)
    puts "using binary gcd(#{a}, #{b})" if @debug_mode

    shift = 0

    while a != b
      if a % 2 == 0 && b % 2 == 0
        a = a / 2
        b = b / 2
        shift += 1
      elsif a % 2 == 0
        a = a / 2
      elsif b % 2 == 0
        b = b / 2
      elsif a > b
        a = (a-b)/2
      else
        b = (b-a)/2
      end
      #debug
      sleep 0.5 if @debug_mode 
      puts "gcd(#{a}, #{b})" if @debug_mode
    end
    
    return a * (2 ** shift) 
  end

  def gcd_ext(a, b, first = true)
    puts "using extended gcd(#{a}, #{b})" if @debug_mode && first

    if a == 0
      return b, 0, 1
    else
      res, x, y = gcd_ext(b%a, a, false)
      #debug
      sleep 0.5 if @debug_mode
      puts "gcd(#{a}, #{b}); koeff: (#{x}, #{y})" if @debug_mode
      return res, y - (b / a) * x, x
    end
  end

  def inverse(a, md)
    puts %{using inverse of #{a} in #{md}} if @debug_mode
    gcd, x, _ = gcd_ext(a, md)
    puts %{gcd = #{gcd}, x = #{x}} if @debug_mode
    if gcd != 1
      raise "\nNo inverse element exists\n"
    else
      return x % md
    end
  end

  def chineese_reminder_theorem(coefficients, modulus)
    puts %{using chineese_reminder_theorem for #{coefficients} in #{modulus}} if @debug_mode
    x = 0
    fact = modulus.reduce(:*)

    coefficients.zip(modulus).each do |a, m|
      ci = fact / m
      ci_inv = inverse(ci, m)
      x += a * ci * ci_inv
    end
    
    x %= fact

    return x
  end

end