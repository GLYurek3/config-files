function tarc --wraps=tar\ cf\ -\ \ -P\ \|\ pv\ -s\ \(du\ -sb\ \ \|\ awk\ \'\{print\ \}\'\)\ \|\ gzip\ \>\ .tar.gz --description alias\ tarc\ tar\ cf\ -\ \ -P\ \|\ pv\ -s\ \(du\ -sb\ \ \|\ awk\ \'\{print\ \}\'\)\ \|\ gzip\ \>\ .tar.gz
  tar cf -  -P | pv -s (du -sb  | awk '{print }') | gzip > .tar.gz $argv; 
end
