require 'set'

# merge two constrains
# {:param => Set[:constrain1, :constrain2]}
# {:param => Set[:constrain2, :constrain3]}
# result => {:param => Set[:constrain1, :constrain2, :constrain3]}
def merge_constrains(left_constrains, right_constrains)
  # not pure function
  # right_constrains.each do |k, v|
  #   if left_constrains.has_key? k
  #     left_constrains[k].merge v
  #   else
  #     left_constrains.merge!({k => v})
  #   end
  # end
  # left_constrains

  # pure function version
  left_constrains.merge(right_constrains.reduce({}) do |sum, (k, v)|
    if left_constrains.has_key? k
      sum.merge({k => left_constrains[k].merge(v)})
    else
      sum.merge({k => v})
    end
  end)
end

# reverse constrains, for example
# {:param1 => Set[:Num], :param2 => Set[:Num]}
# Set[:Num] => [:param1, :param2]
# if use hash.invert, will to be {}Set[:Num] => [:param2]}
def invert_constrains(constrains)
  constrains.reduce({}) do |sum, (k, v)|
    sum.merge(
        if sum.has_key? v
          {v => ([k] + sum[v])}
        else
          {v => [k]}
        end)
  end
end

# mark param by a + id
def remark_constrains_name(invert_constrains)
  invert_constrains.each_with_index.reduce({}) do |sum, ((type_constrains, _), index)|
    sum.merge({type_constrains => "a#{index + 1}".to_sym})
  end
end

# Multiple constrains is associate to name
# so associate every constrains to name
def associate_constrain_and_name(remark_constrains_name)
  remark_constrains_name.map do |(constrains, name)|
    constrains
        .map { |constrain| [constrain, name] }
  end.flatten(1)
end

# translate array of [constrain, name] to str
def constrains_str(constrains)
  associate_constrain_and_name(
      remark_constrains_name(
          invert_constrains(constrains)))
      .map { |pair| pair.join(' ') }.join(', ')
end

class TypeDescription
  attr_accessor :node, :node_env, :name

  def initialize(node, node_env = {})
    @node, @node_env = node, node_env
    if @node.methods.include? :name
      @name = @node.name
    else
      @name = ''
    end
  end

  # f :: (Num a, Ord a) => a -> a
  def inspect
    node_constrains = @node.type_constrains @node_env
    "#{name} :: (#{constrains_str node_constrains}) => " + (signature node_constrains)
  end

  def name
    if @name.empty?
      @node
    else
      @name
    end
  end

  def signature(type_constrains)
    if @node.is_a? Fun
      remark_invert_names = remark_constrains_name invert_constrains type_constrains
      return_type = remark_invert_names.fetch([@node.return_type(@node_env)], :a)
      @node.params.map do |param|
        remark_invert_names[type_constrains[param]]
      end.append(return_type).join(' -> ')
    else
      # TODO:other type, function / array
      'a1'
    end
  end
end