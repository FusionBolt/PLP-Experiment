current_dir = File.dirname(__FILE__)

require 'rspec'
require "#{current_dir}/spec_helper"
require "#{current_dir}/../helper"
require "#{current_dir}/../type"

describe 'TypeConstrain' do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  context 'when condition' do
    temp = {:param1 => Set.new(%i[Num Ord]),
                  :param2 => Set.new(%i[Num])}
    constrains = TypeConstrain.new(temp, $symbol_table)
    it 'succeeds' do
      expect(constrains.invert_constrains).to eq({Set[:Num, :Ord] => [:param1], Set[:Num] => [:param2]})
    end
  end
end