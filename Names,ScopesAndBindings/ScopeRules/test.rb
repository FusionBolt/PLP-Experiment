def lexical_scope
    def scope
        a = 1
        -> { p a }
    end

    a = 2
    f = scope
    f.call # will output 1
end

def scope_cannot_nest
    a = 1
    def nest_scope
        p a 
    end
    # if run nest_scope(), will error:
    # undefined local variable or method 'a'
end

def scope_after_declaration
    # p name 
    name = 'name'
    # undefined local variable or method 'a' 
end 


class B
end
class A
  attr_reader :a, :b
  def initialize
    @b = B.new
    @a = 1
    @b.set_a self
  end
end
class B
  attr_reader :a, :b
  def initialize
    @b = 2
  end

  def set_a(a)
    @a = a
  end
end

def types_utually_recursive
  a = A.new
  p a.a
  b = a.b
  p b.b
end

class SubroutinesMutuallyRecursice
    def f1(run = true)
        p 'call f1'
        self.f2 false if run
    end

    def f2(run = true)
        p 'call f2'
        self.f1 false if run
    end
end
def subroutines_mutually_recursice
    SubroutinesMutuallyRecursice.new.f1
end

def subroutines_class_and_bound_times
    # store in variable
    # pass by value
    # return from function
    def f(&block)
        a = block
        a.call
        block
    end

    f do 
        p 'in subroutines_class_and_bound_times'
    end
    # bind in compile
end

lexical_scope
scope_cannot_nest
scope_after_declaration
types_utually_recursive
subroutines_mutually_recursice
subroutines_class_and_bound_times