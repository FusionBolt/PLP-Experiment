require './type'

if_v = If.new(BinOp.new('<',
                        Identifier.new('a'),
                        Identifier.new('b')),
              Identifier.new('a'),
              Identifier.new('b'))
ff = Fun.new('foo', Param.new('a', 'b'),
             Expr.new(
                 BinOp.new('+',
                           Identifier.new('a'),
                           if_v)))
p TypeDescription.new(ff, $symbol_table).inspect