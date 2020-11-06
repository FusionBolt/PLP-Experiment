def permutation(n, generator, list = [])
  if list.size == n
    generator.yield list
    return
  end
  (1..n).each do |v|
    next if list.include? v
    permutation n, generator, list + [v]
  end
end

def all_permutation(n)
  Enumerator.new do |generator|
    permutation n, generator
  end
end

all_permutation(4).each do |v|
  p v
end
