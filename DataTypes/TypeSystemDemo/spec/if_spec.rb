current_dir = File.dirname(__FILE__)

require 'rspec'
require "#{current_dir}/spec_helper"
require "#{current_dir}/../type"

describe 'If' do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  context 'when if is correct' do
    if_v = If.new(Expr.new(Literal.new(true)),
                  Expr.new(Literal.new(1)),
                  Expr.new(Literal.new(2)))
    it 'type should be left val' do
      expect(if_v.type).to be :Num
    end
    it 'type valid should be true' do
      expect(if_v.type_valid?).to be true
    end
    it 'type constrains should be {}' do
      expect(if_v.type_constrains).to eq({})
    end
  end
end