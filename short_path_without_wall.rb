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
  
    def initialize(start, goal)
      @cost = Hash.new(Float::INFINITY) # 各ノードへのコストを無限大で初期化
      @current = start
      @goal = goal
      @queue = [start] # スタート位置をキューに追加
      @cost[start] = 0 # スタート位置のコストは0
    end
  
    def find_path
      until queue.empty?
        self.current = queue.shift # キューからノードを取り出す
        return cost[current] if current == goal # ゴールに到達した場合
  
        puts "現在のノード: #{current}"
        puts "現在のキュー: #{queue}"
        puts "各ノードへのコスト: #{cost}"
  
        access_adjacent(current).each do |adj_node|
          next_cost = cost[current] + 1 # 隣接ノードへの移動コストを1とする
          if next_cost < cost[adj_node]
            cost[adj_node] = next_cost
            queue.push(adj_node)
          end
        end
      end
      cost[goal]
    end
  
    private
  
    def access_adjacent(node)
      x, y = node
      [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].select { |nx, ny| valid_node?(nx, ny) }
    end
  
    def valid_node?(x, y)
      x >= 0 && y >= 0 # 有効なノードの条件
    end
  end
  
  # スタートとゴールの位置設定
  start = [0, 0] # スタート位置
  goal = [2, 2]  # ゴール位置
  
  # インスタンス化と経路探索
  node = Node.new(start, goal)
  puts "最短コスト: #{node.find_path}"
  