current_dir = File.dirname(__FILE__)

require 'rspec'
require "#{current_dir}/spec_helper"
require "#{current_dir}/../type"

def literal_type(v)
  Literal.new(v).type
end

def literal_type_constrains(v)
  Literal.new(v).type_constrains
end

describe 'Literal' do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  context 'Init' do
    it 'type true' do
      expect(literal_type(1)).to be :Num
      expect(literal_type('str')).to be :String
      expect(literal_type(true)).to be :Bool
    end
    it 'valid and constrains correctness' do
      expect(literal_type_constrains(1)).to eq({})
      expect(literal_type_constrains(1)).to eq({})
    end
  end
end