function nc --wraps=ncmpcpp --description 'alias nc ncmpcpp'
tmux send-keys "ncmpcpp" C-m
tmux select-pane -t 1
tmux split-window -v
tmux send-keys "ncmpcpp" C-m
tmux send-keys 9
tmux send-keys u
tmux send-keys "\\"
tmux resize-pane -t 1 -y 63
#tmux resize-pane -t 1 -x 290 -y 63
tmux resize-pane -t 2 -y 24
tmux select-pane -t 1
end
