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

class Node(start, goal) # ([],[]) 
    def initialize
        @cost = 0
        @current = start
        @status = "S"
        @queue = []
        @goal = goal
    end


    # 前後左右の隣接するマスのコストの配列を返す
    def access_adjacent
        x = [-1,1,0,0]
        y = [0,0,-1,1]

        left = [@current[0]+x[0],@current[0]+y[0]]
        right = [@current[1]+x[1],@current[1]+y[1]]
        down = [@current[2]+x[2],@current[2]+y[2]]
        up = [@current[3]+x[3], @current[3]+y[3]]

        # @current + left...

        return [left,right,down,up].map {|node| calc_cost(node)}
    end

    # マスのコストを算出する node []
    def calc_cost(node)
        (@goal[0]-node[0]).abs + (@goal[1]-node[1]).abs # ゴールとの距離を返す
    end

    # @queueを適切に使用し、@currentを適切な場所に移動させる
    def move_current
    end

    # 直近で計算した隣接ノードのコストを比較し、必要であれば更新する
    def update_cost(node)
        prev = #場所.cost
    end
        
end

