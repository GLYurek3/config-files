function gcm --wraps='git commit -a -S' --description 'alias gcm git commit -a -S'
  git commit -a -S $argv; 
end
