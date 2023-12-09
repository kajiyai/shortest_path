require 'graphviz'

# 新しいGraphvizグラフを作成
g = GraphViz.new(:G, type: :digraph)

# ノードを追加
node1 = g.add_nodes('Node1')
node2 = g.add_nodes('Node2')

# エッジ（ノード間の線）を追加
g.add_edges(node1, node2)

# グラフをPNG形式で出力
g.output(png: 'test_graph.png')
