require './helper'

class Fun
  attr_accessor :name, :params, :body, :param_type_constrains

  def initialize(name, params, body, type_constrains = {})
    @name, @params, @body, @param_type_constrains = name, params, body, type_constrains
  end

  def type_valid?(env = {})
    @body.type_valid? full_env env
  end

  def type(env = {})
    params_type(env).append(return_type(env))
  end

  def type_constrains(env = {}, self_constraint = [])
    if @param_type_constrains.any?
      @param_type_constrains
    else
      # filter :a in constrain
      # reduce :a's exposure
      (@body.type_constrains (full_env env), self_constraint).reduce({}) do |sum, (name, constrain)|
        sum.merge({name => Set.new(remove_excess_generic_a(constrain))})
      end
    end
  end

  def params_type(env = {})
    if @param_type_constrains.any?
      @param_type_constrains[0..-2]
    else
      # params type and return type
      constrains = type_constrains env
      @params.map do |param|
        constrains.fetch(param, :a)
      end
    end
  end

  def return_type(env = {})
    if @param_type_constrains.any?
      @param_type_constrains[-1]
    else
      @body.type full_env env
    end
  end

  private
  def remove_excess_generic_a(constrain)
    # not only :a
    if constrain.size != 1
      constrain.filter { |v| v != :a }
    else
      constrain
    end
  end

  def full_env(env)
    # TODO:change name=>""
    env.merge(@param_type_constrains).merge(@params.announce).merge({@name => ""})
  end
end

class SymbolTable < Hash
  # record(class) member fun/type -> symbol table
  # function type [param type1, param type2, return type]
  # variable type-val
  def initialize
    num_op = %i[+ - * /]
    generic_num_op = generate_op_env(num_op, %i[Num Num Num])
    comparable_op = %i[< >]
    generic_comparable_op = generate_op_env(comparable_op, %i[Ord Ord Bool])
    op_env = generic_num_op.merge(generic_comparable_op)
    new_hash = {
        :Num => generic_num_op,
        :Ord => generic_comparable_op}
    update new_hash.merge op_env
  end

  private

  def generate_op_env(op_array, type_constrains)
    op_array.reduce({}) do |sum, op|
      sum.merge({op => Fun.new(op, [], [], type_constrains)})
    end
  end

end

$symbol_table = SymbolTable.new

class Literal
  attr_accessor :val

  def initialize(val)
    @val = val
  end

  def type_valid?
    true
  end

  def type(env = {})
    s = val.class.to_s.to_sym
    case s
    in :TrueClass | :FalseClass
      :Bool
    in :Integer
      :Num
    else
      s
    end
  end

  def type_constrains(env = {}, self_constraint = [])
    {}
  end
end

class Expr
  attr_accessor :expr

  def initialize(expr)
    @expr = expr
  end

  def type_valid?(env = {})
    @expr.type_valid? env
  end

  def type(env = {})
    @expr.type env
  end

  def type_constrains(env = {}, self_constraint = [])
    @expr.type_constrains env
  end
end

class Identifier
  attr_accessor :name, :val

  def initialize(name, val = nil)
    @name, @val = name.to_sym, val
  end

  def type_valid?(env = {})
    (not val.nil?) || (env.has_key? @name)
  end

  def type(env = {})
    # val is nil then find env
    # if env not find, is error
    if val.nil?
      if env.has_key? @name
        env[@name].type
      else
        raise RuntimeError, 'val is nil, may be not define in this env'
      end
    else
      @val.type env
    end
  end

  def type_constrains(env = {}, self_constraint = [])
    merge_constrains(
        generate_map(@name, type(env)),
        generate_map(@name, self_constraint))
  end

  private
  def generate_map(name, constrains)
    { name => Set.new([constrains].flatten) }
  end
end


class If
  attr_accessor :cond_expr, :then_expr, :else_expr

  def initialize(cond_expr, then_expr, else_expr)
    @cond_expr, @then_expr, @else_expr = cond_expr, then_expr, else_expr
  end

  def type_valid?(env = {})
    @cond_expr.type(env) == :Bool &&
        @then_expr.type(env) == @else_expr.type(env)
  end

  # type of If is expr
  def type(env = {})
    @then_expr.type env
  end

  def type_constrains(env = {}, self_constraint = [])
    # TODO:refactor
    merge_constrains(
        @cond_expr.type_constrains(env, :Bool),
        merge_constrains(
            (@then_expr.type_constrains env, self_constraint),
            (@else_expr.type_constrains env, self_constraint)))
  end
end

class BinOp
  attr_accessor :op, :left_expr, :right_expr

  def initialize(op, left_expr, right_expr)
    @op, @left_expr, @right_expr = op.to_sym, left_expr, right_expr
  end

  def type_valid?(env = {})
    case [@left_expr.type(env), @left_expr.type(env)]
    in [:a, :a] | [:a, _] | [_, :a]
      true
    in [lt, rt]
      env[lt][@op].params_type[1] == rt
    end
  end

  def type(env = {})
    # forbidden define nest fun
    # so don't process about when expr is a fun
    case [@left_expr.type(env), @right_expr.type(env)]
    in [:a, :a]
      env[@op]
    in [:a, t]
      env[t][@op]
    in [t, :a]
      env[t][@op]
    in [lt, rt]
      env[lt][@op]
    end.return_type env
  end

  def type_constrains(env = {}, self_constraint = [])
    op = env[@op]
    merge_constrains(
         @left_expr.type_constrains(env, op.params_type[0]),
         @right_expr.type_constrains(env, op.params_type[1]))
  end
end

class Generic
  def type(env = {})
    :a
  end

  def type_constrains(env = {}, self_constrains = [])
    {}
  end

  def type_valid?(env = {})
    true
  end
end

class Param < Array
  attr_accessor :params

  def initialize(*params)
    params.each do |v|
      append v.to_sym
    end
  end

  def announce
    reduce({}) do |env, name|
      env.merge({name => Generic.new})
    end
  end
end


class FunCall
  attr_accessor :fun_name, :params

  def initialize(fun_name, params)
    @fun_name, @params = fun_name.to_sym, params
  end

  def type_valid?(env = {})
    return false unless env.has_key? @fun_name
    # except return val
    env[@fun_name][0..-2] == params.map(&:type)
  end

  def type(env = {})
    if env.empty?
      raise RuntimeError, 'call function not exist'
    end
    env[@fun_name][-1]
  end

  def type_constrains(env = {}, self_constraint = [])
    params.reduce({}) do |sum, param|
      merge_constrains(sum, param.type_constrains(env))
    end
  end
end