from math import gcd
from functools import reduce


def gcd():
    def euclidean_algorithm(a, b):
        while b != 0:
            remainder = a % b
            a = b
            b = remainder
        return a


    def binary_gcd_algorithm(a, b):
        shift = 0

        while a != b:
            if a % 2 == 0 and b % 2 == 0:
                a = a // 2
                b = b // 2
                shift += 1
            elif a % 2 == 0:
                a = a // 2
            elif b % 2 == 0:
                b = b // 2
            elif a > b:
                a = (a - b) // 2
            else:
                b = (b - a) // 2

        return a * pow(2, shift)


    def extended_euclidean_algorithm(a, b):
        if a == 0:
            return b, 0, 1
        else:
            gcd, x, y = extended_euclidean_algorithm(b % a, a)
            return gcd, y - (b // a) * x, x


    # Ввод значений a и b
    a = int(input("Введите значение a: "))
    b = int(input("Введите значение b: "))

    # Вызов функций для нахождения НОД
    euclidean_result = euclidean_algorithm(a, b)
    binary_gcd_result = binary_gcd_algorithm(a, b)
    extended_euclidean_result, x, y = extended_euclidean_algorithm(a, b)

    # Вывод результатов
    print("\nНОД по алгоритму Евклида:", euclidean_result)
    print("\nНОД по бинарному алгоритму Евклида:", binary_gcd_result)
    print("\nНОД по расширенному алгоритму Евклида:", extended_euclidean_result)
    print("Коэффициенты x и y для расширенного алгоритма Евклида:", x, y)

def systems():
    def solve_system(n):
        equations = []
        coefficients = []
        modulus = []

        # Ввод коэффициентов и модулей уравнений
        for _ in range(n):
            equation = input().strip().split()
            a = int(equation[0])  # коэффициент
            b = int(equation[1])  # модуль
            equations.append(f'x = {a} (mod {b})')
            coefficients.append(a)
            modulus.append(b)

        # Применение Китайской теоремы об остатках
        def chinese_remainder_theorem(coefficients, modulus):
            def extended_gcd(a, b):
                if a == 0:
                    return b, 0, 1
                else:
                    gcd, x, y = extended_gcd(b % a, a)
                    return gcd, y - (b // a) * x, x

            def find_inverse(a, m):
                gcd, x, _ = extended_gcd(a, m)
                if gcd != 1:
                    raise ValueError("Обратный элемент не существует")
                else:
                    return x % m

            M = 1
            for m in modulus:
                M *= m

            x = 0
            for a, m in zip(coefficients, modulus):
                Ci = M // m
                Ci_inv = find_inverse(Ci, m)
                x += a * Ci * Ci_inv

            return x % M

        result = chinese_remainder_theorem(coefficients, modulus)

        return result


    # Пример использования
    n = int(input("Введите количество сравнений: "))
    result = solve_system(n)
    print("Решение системы:", result)

def gauss():
    def solve_linear_equations(n):
        # Ввод коэффициентов и свободных членов уравнений
        system = []
        for _ in range(n):
            equation = list(map(int, input().split()))
            system.append(equation)

        # Печать исходной системы
        print("Исходная система:")
        for equation in system:
            print(*equation)

        field = int(input("Введите размерность поля: "))

        # Прямой ход метода Гаусса над конечным полем
        for i in range(n):
            # Поиск ведущего элемента
            max_row = i
            for j in range(i + 1, n):
                if abs(system[j][i]) > abs(system[max_row][i]):
                    max_row = j

            # Перестановка строк
            system[i], system[max_row] = system[max_row], system[i]

            # Приведение уравнений к треугольному виду
            for j in range(i + 1, n):
                factor = system[j][i] * pow(system[i][i], -1, field)
                for k in range(i, n + 1):
                    system[j][k] = (system[j][k] - factor * system[i][k]) % field

        # Обратный ход метода Гаусса над конечным полем
        solution = [0] * n
        for i in range(n - 1, -1, -1):
            solution[i] = system[i][n]
            for j in range(i + 1, n):
                solution[i] = (solution[i] - system[i][j] * solution[j]) % field
            solution[i] = solution[i] * pow(system[i][i], -1, field) % field

        # Печать решения
        print("Решение:")
        for i in range(n):
            print(f"x{i+1} =", solution[i])

        # Проверка решения
        print("Проверка:")
        for equation in system:
            sum = 0
            for i in range(n):
                sum = (sum + equation[i] * solution[i]) % field
            print(sum, "=", equation[n])

    # Пример использования функции
    n = int(input("Введите количество уравнений: "))
    solve_linear_equations(n)




def main():
    # gcd()
    # systems()
    gauss()


if __name__ == '__main__':
    main()