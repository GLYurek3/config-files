function c --wraps='tmux respawn-pane -k' --description 'alias c tmux respawn-pane -k'
  tmux respawn-pane -k $argv; 
end
