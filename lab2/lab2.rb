require './methods.rb'

@methods = Methods.new

def s1
  puts "\nВведите дробь (числитель знаменатель):"
  input = gets.strip.split.map(&:to_i)

  if input[0].gcd(input[1]) != 1
    puts "Задана некорректная дробь"
  else
    res = @methods.make_chain(input[0], input[1])
    puts "Разложение в цепную дробь: (#{res[0]}; #{res[1..-1].join(", ")})"
  end
end

def s2
  puts "\nВведите параметры Диофантового уравнения (a b c):"
  input = gets.strip.split.map(&:to_i)

  if input[0].gcd(input[1]) != 1
    puts "НОД(a,b) != 0 - решения нет!"
  else
    puts "Решение Диофантового уравнения: #{@methods.diophantus(input[0], input[1], input[2])}"
  end
end

def s3
  # сделать проверку 84 4
  puts "\nВведите чило и модуль для поиска обратного (a m):"
  input = gets.strip.split.map(&:to_i)

  if input[0].gcd(input[1]) != 1
    puts "НОД(a,m) != 0 - решения нет!"
  else
    puts "Обратный элемент в заданных параметрах: #{@methods.inv_mod(input[0], input[1])}" 
  end
end

def s4
  puts "\nВведите параметры сравнения (a b m):"
  input = gets.strip.split.map(&:to_i)

  if input[0].gcd(input[2]) != 1
    puts "НОД(a,m) != 0 - решения нет!"
  else
    puts "Решение линейного сравнения: #{@methods.diophantus(input[0], input[2], input[1])[0] % input[2]}"
  end
end

def s5
  # проверка Лежандра на простоту p 
  puts "\nВведите параметры (a p):"
  input = gets.strip.split.map(&:to_i)
  res = @methods.jacobi(input[0], input[1])
  puts "Символ Якоби: #{res}" if !res.nil?

  if input[1].prime?
    res = @methods.jacobi(input[0], input[1])
    if res == 0
      puts "Символ Лежандра не может быть найден"
    else
      puts "Символ Лежандра: #{res}"
    end
  else
    puts "Число p не простое, символ Лежандра не может быть найден!"
  end
end

def s6
  puts "\nВведите параметры (a p):"
  input = gets.strip.split.map(&:to_i)

  if !input[1].prime?
    puts "Число p не простое, решения нет!"
  else
    res = @methods.sqrt2(input[0], input[1])
    puts "Квадратный корень a по модулю p: #{res}" if !res.nil?
    if !res.nil?
      puts "#{input[0]} mod #{input[1]} == #{input[0] % input[1]}"
      puts "#{res ** 2} mod #{input[1]} == #{(res ** 2) % input[1]}"
    end
  end
end

def go
  input = -1

  while input != 0
    puts "\n[1] --> разложение в цепную дробь"
    puts "\n[2] --> решение диофантова уравнения"
    puts "\n[3] --> вычисление обратного элемента в кольце"
    puts "\n[4] --> решение линейного сравнения"
    puts "\n[5] --> вычисление символов Лежандра и Якоби"
    puts "\n[6] --> извлечение квадратных корней в кольце вычетов"
    puts "\n[0] --> выход из программы"

    puts "\n\nВведите выбор:"
    input = gets.strip.to_i

    case input
    when 1
      s1
    when 2
      s2
    when 3
      s3
    when 4
      s4
    when 5
      s5
    when 6
      s6
    else
      puts "\n\nКонец работы программы"
      return
    end
  end
end

go