function mon
    tmux send-keys "btop"\n
    tmux split-pane -h
    tmux send-keys "nvtop"\n
    tmux select-pane -t 1

end

