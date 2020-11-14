class Pet
    def print_name
      p 'Pet'
    end
  
    def self.dynamic_scope_name
      alias_method :dynamic_scope_name, :print_name
    end
  
    def self.lexical_scope_name
      alias :lexical_scope_name :print_name
    end
  end
  
  class Cat < Pet
    def print_name
      p 'Cat'
    end
    lexical_scope_name
    dynamic_scope_name
  end
  
  Cat.new.print_name # Cat
  Cat.new.lexical_scope_name # Pet
  Cat.new.dynamic_scope_name # Cat