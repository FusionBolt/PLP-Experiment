current_dir = File.dirname(__FILE__)

require 'rspec'
require "#{current_dir}/spec_helper"
require "#{current_dir}/../helper"
require "#{current_dir}/../type"

describe 'Helper' do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  context 'merge_constrains' do
    s1 = Set.new(%i[v1 v2])
    s2 = Set.new(%i[v3 v4])
    h1 = {:a => s1, :b => s1}
    h2 = {:a => s2, :c => s1}
    it 'correct merge' do
      expect(merge_constrains h1, h2).to eq(
                                          {:a => Set.new(%i[v1 v2 v3 v4]),
                                           :b => s1,
                                           :c => s1})
      expect(merge_constrains h1, {}).to eq(h1)
    end
  end

  context 'type constrains str' do
    it '' do
      constrains = {:param1 => Set.new(%i[Num Ord]),
                    :param2 => Set.new(%i[Num])}
      invert = invert_constrains constrains
      expect(invert).to eq({Set[:Num, :Ord] => [:param1], Set[:Num] => [:param2]})
      remark = remark_constrains_name invert
      expect(remark).to eq({Set[:Num, :Ord] => :a1, Set[:Num] => :a2})
      associate = associate_constrain_and_name remark
      expect(associate).to eq([[:Num, :a1], [:Ord, :a1], [:Num, :a2]])
    end
    it '' do
      if_v = If.new(BinOp.new('<',
                              Identifier.new('param1'),
                              Identifier.new('param2')),
                    Identifier.new('param1'),
                    Identifier.new('param2'))
      ff = Fun.new('foo', Param.new('param1', 'param2'),
                   Expr.new(
                       BinOp.new('+',
                                 Identifier.new('param1'),
                                 if_v)))
      constrains = ff.type_constrains SymbolTable.new
      invert = invert_constrains constrains
      expect(invert).to eq({Set[:Num, :Ord] => [:param2, :param1]})
    end
    # {:a=>#<Set: {:a, :Num}>, :b=>#<Set: {:a, :Num}>}
  end
end