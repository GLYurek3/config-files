function gp --wraps='git push -u origin main ' --wraps='git push' --description 'alias gp git push'
  git push $argv; 
end
