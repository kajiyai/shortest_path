#### 入力例1

input1 = "3 3\nS..\n...\n..G"

input1.each_line do |i|
    puts input1[i]
end

# ダイクストラ法
# 初期値 スタート:0, それ以外: infinite
# 1. 未確定状態のノードの中で最小を確定させる
# 2. 直近で確定させたノードに隣接するノードのコストをしらべて、必要であれば更新する
# 3. 1.2を繰り返す


# 最小のコストを確定させるにはソートをする必要はなく、minのみを求める
# 最小のコストを正しい順番で調べていくにはキューを使用する
# カレントノードは直近で決定したノードとする

class Node
    attr_accessor :cost, :current, :queue, :goal
  
    def initialize(start, goal, grid_size_x, grid_size_y)
      @grid_size_x = grid_size_x
      @grid_size_y = grid_size_y
      @cost = Hash.new(Float::INFINITY)
      @current = start
      @goal = goal
      @queue = [start]
      @cost[start] = 0
    end
  
    def find_path
      until queue.empty?
        self.current = queue.shift
  
        display_grid # グリッドを表示
  
        return cost[current] if current == goal
  
        access_adjacent(current).each do |adj_node|
          next_cost = cost[current] + 1
          if next_cost < cost[adj_node]
            cost[adj_node] = next_cost
            queue.push(adj_node) unless queue.include?(adj_node)
          end
        end
      end
      cost[goal]
    end
  
    private
  
    def display_grid
      puts "\nグリッドの状態:"
      @grid_size_x.times do |x|
        @grid_size_y.times do |y|
          print_node([x, y])
        end
        puts
      end
      puts "現在のキュー: #{queue}"
    end
  
    def print_node(node)
      if node == current
        print " C " # 現在のノード
      elsif node == goal
        print " G " # ゴール
      elsif queue.include?(node)
        print " Q " # キューに含まれるノード
      else
        cost = @cost[node]
        print cost.infinite? ? " . " : " #{cost} "
      end
    end
  
    def access_adjacent(node)
      x, y = node
      [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].select { |nx, ny| valid_node?(nx, ny) }
    end
  
    def valid_node?(x, y)
      x >= 0 && y >= 0 && x < @grid_size_x && y < @grid_size_y
    end
  end
  
  # スタートとゴールの位置設定、グリッドサイズの設定
  start = [0, 0]
  goal = [2, 4]
  grid_size_x = 3
  grid_size_y = 5
  
  # インスタンス化と経路探索
  node = Node.new(start, goal, grid_size_x, grid_size_y)
  puts "最短コスト: #{node.find_path}"
  