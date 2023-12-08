#### 入力例1

input1 = "3 3\nS..\n...\n..G"

input1.each_line do |i|
    puts input1[i]
end

# ダイクストラ法
# 初期値 スタート:0, それ以外: infinite
# 1.最小のコストに隣接するコストをしらべる
# 2.その中で最小のコストを確定させる
# 3.1~2を繰り返す


# 最小のコストを確定させるにはソートをする必要はなく、minのみを求める
# 最小のコストを正しい順番で調べていくにはキューを使用する

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

        left = [x[0],y[0]]
        right = [x[1],y[1]]
        down = [x[2],y[2]]
        up = [x[3], y[3]]

        # @current + left...

        # TOOD: 前後左右のコストを計算する
    end

    # マスのコストを算出する
    def calc_cost
        (@goal[0]-@current[0]).abs + (@goal[1]-@current[1]).abs # ゴールとの距離を返す
    end

    # @queueを適切に使用し、@currentを適切な場所に移動させる
end

