function unmirrorscr --wraps='xrandr --output DP2-2 --rotate normal & xrandr --output DP2-2 --reflect normal' --wraps='xrandr --output DP2-2 --rotate normal && xrandr --output DP2-2 --reflect normal' --description 'alias unmirrorscr xrandr --output DP2-2 --rotate normal && xrandr --output DP2-2 --reflect normal'
  xrandr --output DP2-2 --rotate normal && xrandr --output DP2-2 --reflect normal $argv; 
end
