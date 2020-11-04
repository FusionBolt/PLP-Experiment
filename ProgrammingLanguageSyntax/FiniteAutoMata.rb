# code reference by Understanding Computation: From Simple Machines to Impossible Programs

# Deterministic Finite AutoMata
# 1. no conflict
# can't have multiple rules for the same input
# state to state
# 2. no missing
# undefined when missing rule
def assert_true(a)
  raise RuntimeError unless a
end
def assert_false(a)
  raise RuntimeError if a
end

class Rule < Struct.new(:state, :character, :next_state)
  def conform?(state, character)
    self.state == state && self.character == character
  end
end

class DFARuleBook < Struct.new(:rules)
  def next_state(state, character)
    self.rules.detect { |rule| rule.conform? state, character }.next_state
  end
end

class DFA < Struct.new(:current_state, :accept_states, :rulebook)
  def accept?
    accept_states.include? current_state
  end

  def read_character(character)
    self.current_state = self.rulebook.next_state self.current_state, character
  end

  def read_string(string)
    string.each_char { |character| read_character character }
  end
end

# if DFACreator is not exist
# it will be troublesome when read multiple string by same rules and accept_states
# example:
# dfa = DFA.new(1, [3], rulebook)
# dfa1 = dfa.dup
# dfa.read_string dfa1.read_string
class DFACreator < Struct.new(:start_state, :accept_states, :rulebook)
  def to_dfa
    DFA.new(start_state, accept_states, rulebook)
  end

  def accepts?(string)
    to_dfa.tap { |dfa| dfa.read_string string }.accept?
  end
end

def dfa_demo
  rulebook = DFARuleBook.new(
      [Rule.new(1, 'a', 2), Rule.new(1, 'b', 1),
       Rule.new(2, 'a', 2), Rule.new(2, 'b', 3),
       Rule.new(3, 'a', 3), Rule.new(3, 'b', 3)])
  dfa = DFACreator.new(1, [3], rulebook)
  assert_true dfa.accepts? 'aab'
  assert_true dfa.accepts? 'aabbaa'
  assert_false dfa.accepts? 'bbb'
end

# NonDeterministic Finite AutoMata
# 1. one input mapping multiple rules
# set of states to set of states
# 2. free move
class NFARuleBook < Struct.new(:rules)
  def next_states(states, character)
    states.flat_map { |state| confirm state, character }.to_set
  end

  def confirm(state, character)
    rules.select { |rule| rule.conform? state, character }.collect{ |rule| rule.next_state }
  end

  def free_move(states)
    free_states = next_states(states, nil)
    if free_states.subset? states
      states
    else
      free_move(states + free_states)
    end
  end

  def all_character
    rules.map(&:character).compact.uniq
  end
end


require 'set'
class NFA < Struct.new(:current_states, :accept_states, :rulebook)
  def current_states
    rulebook.free_move(super)
  end

  def accept?
    (current_states & accept_states).any?
  end

  def read_character(character)
    self.current_states = rulebook.next_states self.current_states, character
  end

  def read_string(string)
    string.each_char { |character| read_character character}
  end
end

class NFACreator < Struct.new(:start_state, :accept_states, :rulebook)
  # because of free move, start_state is converted to set of start_states
  def to_nfa(current_states = Set[start_state])
    NFA.new(current_states, accept_states, rulebook)
  end

  def accepts?(string)
    to_nfa.tap { |nfa| nfa.read_string string }.accept?
  end
end

def nfa_demo
  rulebook = NFARuleBook.new([
                                 Rule.new(1, nil, 2), Rule.new(1, nil, 4), Rule.new(2, 'a', 3),
                                 Rule.new(3, 'a', 2),
                                 Rule.new(4, 'a', 5),
                                 Rule.new(5, 'a', 6),
                                 Rule.new(6, 'a', 4)
                             ])
  dfa = NFACreator.new(1, [2, 4], rulebook)
  assert_true dfa.accepts? 'aa'
  assert_true dfa.accepts? 'aaaa'
  assert_false dfa.accepts? 'a'
end

# NFA Simulation DFA
# NFA states maybe reach multiple states
# treat multiple states as one states

class NFASimulation < Struct.new(:nfa_creator)
  def next_state(state, character)
    nfa_creator.to_nfa(state).tap { |nfa| nfa.read_character character }.current_states
  end

  def rules_for(state)
    # get all character
    # one state to all character
    nfa_creator.rulebook.all_character.map { |character|
      Rule.new(state, character, next_state(state, character))
    }
  end

  # get all states by recursive
  # compute rule about states
  def generate_rulebook(states)
    # new rules, [one state to all character] * states.size
    rules = states.flat_map { |state| rules_for state}
    # all rules
    more_states = rules.map(&:next_state).to_set
    # if true, then all states rule had been added to rules
    if more_states.subset? states
      [states, rules]
    else
      generate_rulebook(states + more_states)
    end
  end

  def to_dfa_creator
    start_state = nfa_creator.to_nfa.current_states
    states, rules = generate_rulebook Set[start_state]
    accept_states = states.select { |state| nfa_creator.to_nfa(state).accept? }
    DFACreator.new(start_state, accept_states, DFARuleBook.new(rules))
  end
end

def simulation_demo
  rulebook = NFARuleBook.new([
                                 Rule.new(1, 'a', 1), Rule.new(1, 'a', 2), Rule.new(1, nil, 2), Rule.new(2, 'b', 3),
                                 Rule.new(3, 'b', 1), Rule.new(3, nil, 2)
                             ])
  nfa_creator = NFACreator.new(1, [3], rulebook)
  simulation = NFASimulation.new(nfa_creator)
  dfa_creator = simulation.to_dfa_creator

  assert_false dfa_creator.accepts?('aaa')
  assert_true dfa_creator.accepts?('aab')
  assert_true dfa_creator.accepts?('bbbabb')
end

dfa_demo
nfa_demo
simulation_demo