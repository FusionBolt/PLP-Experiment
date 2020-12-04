current_dir = File.dirname(__FILE__)

require 'rspec'
require "#{current_dir}/spec_helper"
require "#{current_dir}/../type"

describe 'BinOp' do
  before do
    @env = SymbolTable.new
    @env.merge! ({:foo1 => Literal.new(1), :foo2 => Literal.new(2)})
    # Do nothing
  end

  after do
    # Do nothing
  end

  context 'when integer add' do
    bin_op = BinOp.new('+',
                       Literal.new(1),
                       Literal.new(2))
    it 'type should be Num' do
      expect(bin_op.type @env).to be :Num
    end
    it 'type valid should be true' do
      expect(bin_op.type_valid? @env).to be true
    end
  end

  context 'integer and identifier add' do
    bin_op = BinOp.new('+',
                       Literal.new(1),
                       Identifier.new('foo1'))
    it 'type should be Num' do
      expect(bin_op.type @env).to be :Num
    end
    it 'type valid should be true' do
      expect(bin_op.type_valid? @env).to be true
    end
    it 'type constrains should be :foo1 => Set.new(%i[Num Num])' do
      expect(bin_op.type_constrains @env).to eq(
                                                 {:foo1 => Set.new(%i[Num])})
    end
  end

  context 'double identifier add' do
    bin_op = BinOp.new('+',
                       Identifier.new('foo1'),
                       Identifier.new('foo2'))
    it 'type should be Num' do
      expect(bin_op.type @env).to be :Num
    end
    it 'type valid should be true' do
      expect(bin_op.type_valid? @env).to be true
    end
    it 'type constrains should be type of foo1 and foo2' do
      expect(bin_op.type_constrains @env).to eq(
                                                 {:foo1 => Set.new(%i[Num]),
                                                  :foo2 => Set.new(%i[Num])})
    end
  end

  context 'when two expressions are evaluated' do
    bin_op = BinOp.new('+',
                       BinOp.new('-',
                                 Identifier.new('foo1'),
                                 Literal.new(1)),
                       BinOp.new('*',
                                 Identifier.new('foo2'),
                                 Identifier.new('foo2')))
    it 'type should be Num' do
      expect(bin_op.type @env).to be :Num
    end
    it 'type valid should be true' do
      expect(bin_op.type_valid? @env).to be true
    end
    it 'type constrains should be type of foo1 and foo2' do
      expect(bin_op.type_constrains @env).to eq(
                                                 {:foo1 => Set.new(%i[Num]),
                                                  :foo2 => Set.new(%i[Num])})
    end
  end
end