function tarcxz --wraps=tar\ cf\ -\ \ -P\ \|\ pv\ -s\ \(du\ -sb\ \ \|\ awk\ \'\{print\ \}\'\)\ \|\ gzip\ \>\ .tar.gz --wraps=tar\ cf\ -\ \ -P\ \|\ pv\ -s\ \(du\ -sb\ \ \|\ awk\ \'\{print\ \}\'\)\ \|\ gzip\ \>\ .tar.xz --description alias\ tarcxz\ tar\ cf\ -\ \ -P\ \|\ pv\ -s\ \(du\ -sb\ \ \|\ awk\ \'\{print\ \}\'\)\ \|\ gzip\ \>\ .tar.xz
  tar cf -  -P | pv -s (du -sb  | awk '{print }') | gzip > .tar.xz $argv; 
end
