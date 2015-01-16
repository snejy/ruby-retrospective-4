def fibonacci(n)
    n <= 1 ? n : fibonacci(n - 1) + fibonacci(n - 2)
end

def lucas(n)
    n == 1 ? 2 : n == 2 ? 1 : lucas(n - 1) + lucas(n - 2)
end

def series(row, n)
    row == "summed" ? fibonacci(n) + lucas(n) : send(row, n)
end