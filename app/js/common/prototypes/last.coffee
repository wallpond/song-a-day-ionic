Array::last = (n) ->
  n = if typeof n != 'undefined' then n else 1
  @[@length - n]
