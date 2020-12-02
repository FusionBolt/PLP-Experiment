require 'continuation'

def test
  callcc { |cont| return cont }
  print "return from test, " # if is p, will return nil
end

print "before test, "
c = test
print "after test, "
if c
  p 'will call callcc'
  c.call
else
  p 'because from callcc, exec next line of callcc, so c is nil'
end

# callcc is obsolete
# infact use Fiber instead