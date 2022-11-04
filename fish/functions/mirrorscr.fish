function mirrorscr --wraps=' xrandr --output DP2-2 --rotate inverted & xrandr --output DP2-2 --reflect y' --wraps=' xrandr --output DP2-2 --rotate inverted && xrandr --output DP2-2 --reflect y' --description 'alias mirrorscr  xrandr --output DP2-2 --rotate inverted && xrandr --output DP2-2 --reflect y'
   xrandr --output DP2-2 --rotate inverted && xrandr --output DP2-2 --reflect y $argv; 
end
