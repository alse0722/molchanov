def can_be_solved?(matrix = [])

    if matrix.empty?
      raise "Not enough data!"
    end

    not_ok = false

    matrix.each do |raw|
      pp raw
      raw_not_ok = false
      raw[1..-2].each {|element| raw_not_ok = raw_not_ok && (element == 0)}
      # pp raw_not_ok
      not_ok = not_ok && (raw_not_ok || raw[-1] != 0)
    end

    !not_ok
  end

  def swap_null_raws(matrix, id)

    default = matrix
    
    return matrix if matrix.size == id + 1

    while default[id][id] == 0
      default << default[id]
      default.delete_at(id)
    end

    default
  end

  def delete_null_raws(matrix)
    res = []
    matrix.each_with_index do |raw, id|
      null_raw = true
      raw.each {|el| null_raw = null_raw && (el == 0)}

      if !null_raw
        res << matrix[id]
      end
    end

    res
  end

  def summ_arrays(a,b, field_dimension)
    res = []
    a.each_with_index do |el, i|
      res << (el + b[i]) % field_dimension
    end

    res
  end


  def gauss(matrix = [], field_dimension = 0)
    
    if @debug_mode
      puts %{using gauss for matrix: #{matrix}}
    end

    if matrix.empty? || field_dimension == 0
      raise "Not enough data!"
    end

    matrix.each_with_index do |raw, i|
      if !can_be_solved?(matrix)
        raise "Matrix cant be solved!"
      end

      puts %{debug: in swap_null_raws}
      matrix = swap_null_raws(matrix, i)
      puts %{debug: out swap_null_raws}

      if matrix[i][i] != 1
        matrix[i] = matrix[i].each {|el| el *= gcd_ext(field_dimension, matrix[i][i])[2] % field_dimension}
      end
      puts %{debug: mult}

      matrix.each_with_index do |_, j|
        if j != i
          matrix[j] = summ_arrays(matrix[j], matrix[i].each {|el| el *= (field_dimension - matrix[j][i]) % field_dimension}, field_dimension)
        end
      end
      puts %{debug:summ_arrays}

      matrix = delete_null_raws(matrix)
      puts %{debug:delete_null_raws}

    end

    pp matrix

    matrix
    # puts %{Matrix can be colved? #{can_be_solved?(matrix)}}
  end