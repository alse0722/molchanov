import time
from random import randint
from math import gcd, sqrt, ceil, log2, log


def timer(f):
   def wrapper(*args, **kwargs):
      start = time.perf_counter()
      ans = f(*args, **kwargs)
      end = time.perf_counter()
      print(f'Time: {(end - start) * 1000:.3f}ms')
      return ans
   return wrapper


def egcd(a, b):
    if a == 0:
        return b, 0, 1
    g, x, y = egcd(b % a, a)
    return g, y - (b // a) * x, x


def mulinv(b, n):
    g, x, _ = egcd(b, n)
    if g == 1:
        return x % n


def check_group(g, b):
    elements = []
    for i in range(1, b):
        elements.append(pow(g, i, b))
    if len(set(elements)) == b - 1:
        return True
    return False


@timer
def g_sh_method(g, b, h):
    r = int(sqrt(b)) + 1
    ga = [[a, pow(g, a, b)] for a in range(r)]
    ga.sort(key=lambda el: el[1])
    g1 = pow(mulinv(g, b), r, b)
    x = b + 1
    for i in range(r):
        gh = (pow(g1, i, b) * h) % b
        for element in ga:
            if element[1] == gh:
                x = min(x, element[0] + r * i)
            elif element[1] > gh:
                break
    return x


def miller_rabin(p, k):
    s, m, i = p - 1, 0, 0
    while not s % 2:
        s //= 2
        m += 1
    while i < k+1:
        a = randint(2, p - 2)
        while gcd(a, p) != 1:
            a = randint(2, p - 2)
        b = pow(a, s, p)
        if b == 1:
            continue
        if b == p - 1:
            i += 1
            continue
        flag = False
        for l in range(1, m):
            c = pow(a, (s * pow(2, l)), p)
            if c == p - 1:
                flag = True
                break
        if flag:
            i += 1
            continue
        return False
    return True


def ext_euclid(a, b):
    i = 1
    r, q = [a, b], [0]
    x, y = [1, 0], [0, 1]
    while True:
        r.append(r[i - 1] % r[i])
        q.append(r[i - 1] // r[i])
        if r[i + 1] == 0:
            d, x, y = r[i], x[i], y[i]
            break
        x.append(x[i - 1] - q[i] * x[i])
        y.append(y[i - 1] - q[i] * y[i])
        i += 1
    return d, x, y


def solve_comparison(a, b, m):
    a, b = a % m, b % m
    d = gcd(m, a)
    if b % d:
        return
    a_new, b_new, m_new = a // d, b // d, m // d
    d_new, q, r = ext_euclid(a_new, m_new)
    q, r = q % m, r % m
    x0 = (b_new * q) % m_new
    for j in range(d):
        yield x0 + m_new * j


def check_group(g, m):
    elements = []
    for i in range(1, m):
        elements.append(pow(g, i, m))
    if len(set(elements)) == m - 1:
        return True
    return False


def f_function(y, g, h, m):
    if y <= m // 3:
        return (h * y) % m
    elif m // 3 < y < (2 * m) // 3:
        return pow(y, 2, m)
    return (g * y) % m


def a_function(y, a, m):
    if y <= m // 3:
        return (a + 1) % (m - 1)
    elif m // 3 < y <= 2 * m // 3:
        return (2 * a) % (m - 1)
    elif 2 * m // 3 < y:
        return a % (m - 1)


def b_function(y, b, m):
    if y <= m // 3:
        return b % (m - 1)
    elif m // 3 < y <= 2 * m // 3:
        return (2 * b) % (m - 1)
    elif 2 * m // 3 < y:
        return (b + 1) % (m - 1)


def next_elements(y, a, b, h, g, m):
    new_y = f_function(y, g, h, m)
    new_a = a_function(y, a, m)
    new_b = b_function(y, b, m)
    return new_y, new_a, new_b


@timer
def p_method(g, m, h, epsilon):
    t = int(sqrt(2*m*log(1/epsilon))) + 1
    while True:
        i = 1
        s = randint(0, m - 2)
        y0, a0, b0 = next_elements(pow(g, s, m), s, 0, h, g, m)
        y1, a1, b1 = next_elements(y0, a0, b0, h, g, m)
        while True:
            y0, a0, b0 = next_elements(y0, a0, b0, h, g, m)
            y1, a1, b1 = next_elements(*(next_elements(y1, a1, b1, h, g, m)), h,g, m)
            if y0 != y1:
                if i >= t:
                    return None
                i += 1
            else:
                new_b = (b0 - b1) % (m - 1)
                new_a = (a1 - a0) % (m - 1)
                d = gcd(new_a, m - 1)
                if d > int(sqrt(m - 1)):
                    break
                for x in solve_comparison(new_a, new_b, m - 1):
                    if pow(g, x, m) == h:
                        return x
                break

def main():
    var = int(input('Выберите режим: 1 - метод Гельфонда-Шенкса, 2 - p-метод Полларда: '))
    if var == 1:
        g = int(input('Введите образующий элемент g конечной циклической группы G: '))
        b = int(input('Введите порядок b конечной циклической группы G: '))
        h = int(input('Введите элемент h из G: '))
        if not miller_rabin(b, ceil(log2(b))):
            print('Введено некорректное значение b')
        if not check_group(g, b):
            print('Введено некорректное значение g!')
        if not 0 <= h <= b - 1:
            print('Введено некорректное значение h!')
        x = g_sh_method(g, b, h)
        print(f'x = {x}')
    elif var == 2:
        g = int(input('Введите образующий элемент g конечной циклической группы G: '))
        m = int(input('Введите порядок b конечной циклической группы G: '))
        h = int(input('Введите элемент h из G: '))
        epsilon = float(input('Введите значение ε: '))
        if not miller_rabin(m, ceil(log2(m))):
            print('Введено некорректное значение b!')
        if not check_group(g, m):
            print('Введено некорректное значение g!')
        if not 0 <= h <= m - 1:
            print('Введено некорректное значение h!')
        if not 0 < epsilon <= 1:
            print('Введено некорректное значение ε!')
        x = p_method(g, m, h, epsilon)
        if x is None:
            print("Вычислить x не удалось!")
        else:
            print(f'x = {x}')


if __name__ == '__main__':
    main()

