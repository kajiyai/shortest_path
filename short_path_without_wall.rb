require 'graphviz'
require 'fileutils'


# ダイクストラ法
# 初期値 スタート:0, それ以外: infinite
# 1. 未確定状態のノードの中で最小を確定させる
# 2. 直近で確定させたノードに隣接するノードのコストをしらべて、必要であれば更新する
# 3. 1.2を繰り返す


# 最小のコストを確定させるにはソートをする必要はなく、minのみを求める
# 最小のコストを正しい順番で調べていくにはキューを使用する
# カレントノードは直近で決定したノードとする

class Node
  attr_accessor :cost, :current, :queue, :goal, :graph

  def initialize(start, goal, grid_size_x, grid_size_y)
    @grid_size_x = grid_size_x
    @grid_size_y = grid_size_y
    @cost = Hash.new(Float::INFINITY)
    @current = start
    @goal = goal
    @queue = [start]
    @cost[start] = 0
    @graph = GraphViz.new(:G, type: :digraph) # Graphvizのグラフを初期化
  end

  def find_path(input_index)
    step_index = 0
    output_dir = "output_#{input_index + 1}"
    FileUtils.mkdir_p(output_dir) unless Dir.exist?(output_dir)

    until queue.empty?
      self.current = queue.shift
      display_grid # コンソールへの出力
      return cost[current] if current == goal

      access_adjacent(current).each do |adj_node|
        next_cost = cost[current] + 1
        next unless next_cost < cost[adj_node]

        cost[adj_node] = next_cost
        queue.push(adj_node) unless queue.include?(adj_node)
        update_graph(current, adj_node) # グラフを更新
      end

      output_graph(input_index, step_index, output_dir) # グラフを出力
      step_index += 1
    end

    output_graph(input_index, step_index, output_dir) # 最終グラフを出力
    cost[goal]
  end

  def update_graph(current, adj_node)
    graph.add_nodes(current.to_s, label: "C(#{current})")
    graph.add_nodes(adj_node.to_s, label: "#{adj_node}(#{cost[adj_node]})")
    graph.add_edges(current.to_s, adj_node.to_s)
  end

  def output_graph(input_index, step_index, output_dir)
    filename = File.join(output_dir, "graph_#{input_index + 1}_#{step_index + 1}.png")
    graph.output(png: filename)
    puts "グラフを #{filename} に出力しました。"
  rescue StandardError => e
    puts "グラフの出力に失敗しました: #{e.message}"
  end

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

# 入力ファイルから入力を読み込む関数
def load_inputs(input_dir)
  inputs = []
  # 指定ディレクトリ内のすべてのinput*.txtファイルを読み込む
  Dir.glob(File.join(input_dir, 'input*.txt')).sort.each do |file_path|
    input = File.read(file_path)
    inputs << input
  end
  inputs
end

# 入力ディレクトリの指定
input_dir = 'inputs'

# 入力を読み込む
inputs = load_inputs(input_dir)

# 入力解析とインスタンス生成、経路探索の実行
inputs.each_with_index do |input, index|
  start, goal, grid_size_x, grid_size_y = parse_input(input)
  node = Node.new(start, goal, grid_size_x, grid_size_y)
  puts "入力: #{input.split("\n").first}"
  puts "最短コスト: #{node.find_path(index)}"
  puts '-' * 30
end
