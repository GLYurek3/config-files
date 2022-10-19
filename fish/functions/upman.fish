function upman --wraps='doas makewhatis /usr/share/man' --description 'alias upman doas makewhatis /usr/share/man'
  doas makewhatis /usr/share/man $argv; 
end
