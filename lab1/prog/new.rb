def exea(a, b)
  return [0, 1] if a % b == 0
  x, y = exea(b, a % b)
  [y, x - y * (a / b)]
end

def mult_row_to_num(row, num, field)
  row.map { |el| (el * num) % field }
end

def add_rows(row1, row2, field)
  row1.each_with_index.map { |el, i| (el + row2[i]) % field }
end

def del_zero_rows(matrix)
  matrix.reject! { |row| row.all?(&:zero?) }
end

def swap_columns(matrix, col)
  (col + 1...matrix[col].size - 1).each do |i|
    if matrix[col][i] != 0
      matrix.each { |row| row[col], row[i] = row[i], row[col] }
      return
    end
  end
end

def gauss(matrix, field)
  matrix.each_with_index do |row, i|
    swap_columns(matrix, i) if row[i] == 0

    rev_el = exea(row[i], field)[0]
    matrix[i] = mult_row_to_num(row, rev_el, field)

    matrix.each_with_index do |row2, j|
      next if i == j
      matrix[j] = add_rows(row2, mult_row_to_num(matrix[i], -row2[i], field), field)
    end
  end

  del_zero_rows(matrix)

  have_solution = !matrix.any? { |row| row.last != 0 && row.take(matrix.size).all?(&:zero?) }

  return matrix, have_solution
end

def get_matrix(matrix)
  matrix.each { |row| puts row.join(' ') }
end

def get_ans(input, field)

  matrix = input[0]
  boo = input[1]

  if !boo
    puts "\nThere are no solutions!"
    return
  end

  puts "\nРазрешённое решение исходной системы: "
  matrix.each do |row|
    row.each_with_index do |el, j|
      if j == row.size - 2
        print "#{el}x#{j + 1} = "
      elsif j == row.size - 1
        puts el
      else
        print "#{el}x#{j + 1} + "
      end
    end
  end

  puts "\nОбщее решение исходной системы: "
  matrix.each_with_index do |row, i|
    print "x#{i + 1} = "
    (i + 1...row.size - 1).each do |j|
      if matrix[i][j] != 0
        matrix[i][j] = -matrix[i][j] + field
        print "#{matrix[i][j]}x#{j + 1} + "
      end
    end
    puts matrix[i].last
  end

  print "\nСвободные неизвестные: "
  vals = gets.chomp.split(',').map(&:to_i)
  res = []
  matrix.each do |row|
    ans = 0
    (matrix.size...row.size - 1).each { |j| ans += vals[j - matrix.size] * row[j] }
    ans += row.last
    res << ans
  end
  res.concat(vals)

  print "Частное решение: ("
  res.each_with_index do |el, i|
    if i == res.size - 1
      print "#{el})"
    else
      print "#{el}, "
    end
  end
end

# Ввод данных
puts "Введите поле (p): "
field = gets.chomp.to_i

puts "Введите количество строк и столбцов матрицы системы: "
rows, cols = gets.chomp.split.map(&:to_i)

puts "Введите матрицу системы: "
matrix = []
rows.times do
  row = gets.chomp.split.map(&:to_i)
  matrix << row
end

# Решение
matrix, have_solution = gauss(matrix, field)

# Вывод результата
puts "\nFinal matrix: "
get_matrix(matrix)
get_ans([matrix, have_solution], field)
