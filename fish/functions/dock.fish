function dock --wraps='xrandr --output DP2-2 --mode 2560x1440 --left-of eDP1 & feh --no-fehbg --bg-fill /home/jy/Pictures/wallpapers/hatchett.jpg' --description 'alias dock xrandr --output DP2-2 --mode 2560x1440 --left-of eDP1 & feh --no-fehbg --bg-fill /home/jy/Pictures/wallpapers/hatchett.jpg'
  xrandr --output DP2-2 --mode 2560x1440 --left-of eDP1 & feh --no-fehbg --bg-fill /home/jy/Pictures/wallpapers/hatchett.jpg $argv; 
end
