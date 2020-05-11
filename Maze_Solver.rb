require_relative "Node"

print "Please enter the name of the file: "
input = gets.chomp

file = File.open(input)
maze = file.readlines

def find_target(maze)
    maze.each_with_index do |row, row_index|
        row.split("").each_with_index do |column, col_index|
            return [row_index, col_index] if column == "E"
        end
    end
end

def find_start(maze)
    maze.each_with_index do |row, row_index|
        row.split("").each_with_index do |column, col_index|
            return [row_index, col_index] if column == "S"
        end
    end
end

starting = find_start(maze)
target = find_target(maze)


def a_start(maze, start, target)
    startNode = Node.new(start)
    targetNode = Node.new(target)

    open_list = []
    closed_list = []
    open_list << startNode

    #debugger
    while open_list.length > 0
        currentNode = open_list[0]
        current_index = 0

        open_list.each_with_index do |node, index|
            if node.f < currentNode.f
                currentNode = node
                current_index = index
            end
        end

        open_list = open_list.select { |node| node if node.position != currentNode.position }
        closed_list << currentNode

        if currentNode.position == targetNode.position
            path = []
            current = currentNode
            while current != nil
                path << current.position
                current = current.parent
            end
            return path
        end

    children = []

    #up
        if maze[currentNode.position[0] - 1][currentNode.position[1]] == " " || maze[currentNode.position[0] - 1][currentNode.position[1]] == "E"
            children << Node.new([currentNode.position[0] - 1, currentNode.position[1]],currentNode)
        end
    #down
        if maze[currentNode.position[0] + 1][currentNode.position[1]] == " " || maze[currentNode.position[0] + 1][currentNode.position[1]] == "E"
            children << Node.new([currentNode.position[0] + 1, currentNode.position[1]], currentNode)
        end
    #left
        if maze[currentNode.position[0]][currentNode.position[1] - 1] == " " || maze[currentNode.position[0]][currentNode.position[1] - 1] == "E"
            children << Node.new([currentNode.position[0], currentNode.position[1] - 1], currentNode)
        end
    #right
        if maze[currentNode.position[0]][currentNode.position[1] + 1] == " " || maze[currentNode.position[0]][currentNode.position[1] + 1] == "E"
            children << Node.new([currentNode.position[0], currentNode.position[1] + 1], currentNode)
        end

        children.each do |child|
            if closed_list.include?(child)
                next
            end

            child.g = currentNode.g + 1
            child.h = ((child.position[0] - targetNode.position[0]) ** 2) + ((child.position[1] - targetNode.position[1]) ** 2)
            child.f = child.g + child.h

            open_list.each do |node|
                if node.position == child.position
                    if child.g > node.g
                        break
                    end
                end
            end
        open_list << child
        end
    end
end



path = a_start(maze, starting, target)

def print_map(maze, path)
    path.shift.pop
    path.each do |pair|
        row = pair[0]
        col = pair[1]
        maze[row][col] = "X"
    end
    puts maze
end

print_map(maze, path)