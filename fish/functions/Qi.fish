function Qi --wraps='doas pacman -Qi ' --description 'alias Qi doas pacman -Qi '
  doas pacman -Qi  $argv; 
end
