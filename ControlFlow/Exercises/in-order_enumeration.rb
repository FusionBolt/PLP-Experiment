class BinTree < Struct.new(:data, :left_child, :right_child)
  def in_order
    Enumerator.new do |generator|
      unless self.left_child.nil?
        self.left_child.in_order.each { |v| generator.yield v }
      end
      unless self.data.nil?
        generator.yield self.data
      end
      unless self.right_child.nil?
        self.right_child.in_order.each { |v| generator.yield v }
      end
    end
  end
end

tree = BinTree.new(5,
            BinTree.new(3,
                        BinTree.new(2,
                                    BinTree.new(1)),
                        BinTree.new(4)),
            BinTree.new(7,
                        BinTree.new(6),
                        BinTree.new(9,
                                    BinTree.new(8),
                                    BinTree.new(10))))

tree.in_order.each do |v|
  p v
end