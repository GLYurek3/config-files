function mans --wraps=man --description 'open a man page off the side to save space'
    tmux split-pane -h
    tmux resize-pane -x 82
    tmux send-keys "man "$argv\n
    tmux select-pane -t 1
end
