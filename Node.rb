class Node
    attr_accessor :parent, :g, :h, :f
    attr_reader :position

    def initialize(position, parent = nil)
        @position = position
        @parent = parent
        @g = 0
        @h = 0
        @f = 0
    end
end