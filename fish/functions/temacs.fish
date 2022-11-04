function temacs --wraps='emacsclient -nw' --description 'alias temacs emacsclient -nw'
  emacsclient -nw $argv; 
end
