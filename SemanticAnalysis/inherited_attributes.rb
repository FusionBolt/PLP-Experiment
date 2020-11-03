class Expr
  attr_reader :const, :val, :tail

  def initialize(const, expr_tail)
    @const = const
    @tail = expr_tail
  end

  def reduce
    @val = @tail.reduce(@const.val)
  end

  def to_s
    "#{@const}#{@st}#{@tail}"
  end
end

class ExprTail < Expr
  attr_reader :op
  attr_accessor :st

  def initialize(*args)
    @op, @const, @tail = args
  end

  def reduce(inherited_val)
    if @op.nil?
      inherited_val
    else
      @tail.reduce(inherited_val - @const.val)
    end
  end

  def to_s
    "#{@op}#{@const}#{@tail}"
  end
end

class Const
  attr_reader :val

  def initialize(val)
    @val = val
  end

  def to_s
    @val.to_s
  end
end

expr = Expr.new(
    Const.new(9), ExprTail.new(
    '-', Const.new(4), ExprTail.new(
    '-', Const.new(3), ExprTail.new(nil)
))
)

p expr.reduce
p expr.to_s