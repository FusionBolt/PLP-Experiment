current_dir = File.dirname(__FILE__)

require 'rspec'
require "#{current_dir}/spec_helper"
require "#{current_dir}/../type"

describe 'FunCall' do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  context 'when call exist fun' do
    env = SymbolTable.new.merge({:foo => %i[Num Num Num]})
    call = FunCall.new('foo', [Literal.new(1), Literal.new(2)])
    it 'param type is valid' do
      expect(call.type_valid? env).to be true
    end
    it 'return type' do
      expect(call.type env).to be :Num
    end
    it 'params constrains' do
      expect(call.type_constrains env).to eq({})
    end
  end
end