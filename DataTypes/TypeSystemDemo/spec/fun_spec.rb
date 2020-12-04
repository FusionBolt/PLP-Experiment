current_dir = File.dirname(__FILE__)

require 'rspec'
require "#{current_dir}/spec_helper"
require "#{current_dir}/../type"

describe 'Fun' do
  before do
    @env = SymbolTable.new
  end

  after do
    # Do nothing
  end

  # TODO:finish
  context 'when no type constrains' do
    ff = Fun.new('foo2', Param.new('v1', 'v2'),
                 Expr.new(
                     BinOp.new('+',
                               Identifier.new('v1'),
                               Identifier.new('v2'))))
    it 'succeeds' do
      # Set[:a, :Num], Set[:a, :Num], :Num
      # expect(ff.type @env).to be %i[Num Num Num]
      # expect(ff.type_valid? @env).to be true
      # expect(ff.type_constrains @env).to eq({:v1 => Set.new(%i[a Num]),
      #                                        :v2 => Set.new(%i[a Num])})
    end
  end

  context 'when have type constrains' do
    ff = Fun.new('foo', Param.new('v1', 'v2', 'v3'),
                 Expr.new(
                     BinOp.new('+',
                               BinOp.new('+',
                                         Identifier.new('v1'),
                                         Identifier.new('v2')),
                               Identifier.new('v3'))),
                 %i[Num Num Num])
    it 'type should be [:Num, :Num, :Num]' do
      # expect(ff.type @env).to eq %i[Num Num Num]
    end
  end
end