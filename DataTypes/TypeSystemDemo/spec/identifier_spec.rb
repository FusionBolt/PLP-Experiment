current_dir = File.dirname(__FILE__)

require 'rspec'
require "#{current_dir}/spec_helper"
require "#{current_dir}/../type"

describe 'Identifier' do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  context 'when id foo has Literal val' do
    id = Identifier.new('foo',  Literal.new(1))
    it 'type should be Literal val type' do
      expect(id.type).to be :Num
    end
    it 'type valid should be true' do
      expect(id.type_valid?).to be true
    end
    it 'type constrains should be foo:Set[:Num]' do
      expect(id.type_constrains).to eq({:foo => Set[:Num]})
    end
  end

  describe 'when id foo has not val' do
    context 'no env' do
      id = Identifier.new('foo')
      it 'type should raise RuntimeError' do
        expect{
          id.type
        }.to raise_error(RuntimeError)
      end
      it 'type valid should be false' do
        expect(id.type_valid?).to be false
      end
      it 'type constrains should raise RuntimeError' do
        expect{
          id.type_constrains
        }.to raise_error(RuntimeError)
      end
    end
    context 'have env' do
      id = Identifier.new('foo')
      env = {:foo => Literal.new(1)}
      it 'type should be Num' do
        expect(id.type env).to be :Num
        expect(id.type_valid? env).to be true
        expect(id.type_constrains env).to eq({:foo => Set[:Num]})
      end
    end
  end

end