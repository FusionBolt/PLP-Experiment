def f2
    p 'run f2, will throw to test'
  throw :test
end

def f1
  p 'will call f2'
  f2
  p 'this statement will not be executed in f1'
end

catch :test do
  p 'call f1'
  f1
  p p 'this statement will not be executed in catch'
end
p 'end'