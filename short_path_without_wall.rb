require 'graphviz'
inputs = [
  # 入力例1
  "3 3\nS..\n...\n..G",

  # 入力例2
  "4 4\nS...\n....\n....\n...G",

  # 入力例3
  "5 3\nS..\n...\n...\n...\n..G",

  # 入力例4
  "3 5\nS....\n.....\n....G",

  # 入力例5
  "6 6\nS.....\n......\n......\n......\n......\n.....G",

  # 入力例6
  "2 5\nS....\n...G.",

  # 入力例7
  "4 4\n...S\n....\n....\nG...",

  # 入力例8
  "6 3\n..S\n...\nG..\n...\n...\n...",

  # 入力例9
  "5 7\n......S\n.......\n.......\n.......\nG......",

  # 入力例10
  "3 10\nG.........\n..........\n.........S"
]


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
    g = GraphViz.new(:G, type: :digraph) # Graphvizのグラフを初期化

    until queue.empty?
      self.current = queue.shift

      display_grid # コンソールへの出力

      return cost[current] if current == goal

      access_adjacent(current).each do |adj_node|
        next_cost = cost[current] + 1
        if next_cost < cost[adj_node]
          cost[adj_node] = next_cost
          queue.push(adj_node) unless queue.include?(adj_node)

          # Graphvizでのノードとエッジの追加
          g.add_nodes(current.to_s, label: "C(#{current})")
          g.add_nodes(adj_node.to_s, label: "#{adj_node}(#{cost[adj_node]})")
          g.add_edges(current.to_s, adj_node.to_s)
        end
      end
    end

    g.output(png: "graph_#{index}.png") # グラフをPNG形式で出力
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
      print ' C ' # 現在のノード
    elsif node == goal
      print ' G ' # ゴール
    elsif queue.include?(node)
      print ' Q ' # キューに含まれるノード
    else
      cost = @cost[node]
      print cost.infinite? ? ' . ' : " #{cost} "
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

# 入力からスタートとゴールの位置、グリッドサイズを抽出する関数
def parse_input(input)
  lines = input.split("\n")
  grid_size_x, grid_size_y = lines.first.split.map(&:to_i)
  grid = lines[1..-1]

  start = nil
  goal = nil

  grid.each_with_index do |line, x|
    line.chars.each_with_index do |char, y|
      start = [x, y] if char == 'S'
      goal = [x, y] if char == 'G'
    end
  end

  [start, goal, grid_size_x, grid_size_y]
end

# 入力解析とインスタンス生成、経路探索の実行
inputs.each_with_index do |input, _index|
  start, goal, grid_size_x, grid_size_y = parse_input(input)

  node = Node.new(start, goal, grid_size_x, grid_size_y)
  puts "入力: #{input.split("\n").first}"
  puts "最短コスト: #{node.find_path}"
  puts '-' * 30
end