function jellyfin --wraps='ssh home -L localhost:8096:localhost:8096 -N' --description 'alias jellyfin ssh home -L localhost:8096:localhost:8096 -N'
  ssh home -L localhost:8096:localhost:8096 -N $argv; 
end
