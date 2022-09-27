function pubip --wraps='curl https://ipinfo.io/ip ; echo' --description 'alias pubip curl https://ipinfo.io/ip ; echo'
  curl https://ipinfo.io/ip ; echo $argv; 
end
