def case_series(n, first, second)
  case n
  when 1 then first
  when 2 then second
  else case_series(n - 1, first, second) + case_series(n - 2, first, second)
  end
end

def series(type, n)
  case type
  when 'fibonacci' then case_series(n, 1, 1)
  when 'lucas'     then case_series(n, 2, 1)
  else series('fibonacci', n) + series('lucas', n)
  end
end